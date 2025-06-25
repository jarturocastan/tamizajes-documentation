# DigitalOcean Spaces - Static Site Hosting

## Configuración Completa para Hosting Estático

### Ventajas de Spaces
- ✅ **CDN global** integrado
- ✅ **Escalabilidad automática**
- ✅ **Precio predecible** ($5/mes + $0.01/GB)
- ✅ **Compatible con S3**
- ✅ **SSL incluido**
- ✅ **Fácil integración con CI/CD**

## Paso 1: Crear Space en DigitalOcean

### 1.1 Crear Space
1. **DigitalOcean Dashboard** → **Spaces**
2. **Create Space**
3. **Configuración**:
   ```
   Name: uneme-docs
   Region: NYC3 (o más cercano)
   File Listing: Public (para web hosting)
   CDN: Enable (recomendado)
   ```
4. **Create Space**

### 1.2 Configurar para Static Website
1. **Space Settings** → **Settings**
2. **Static Website Hosting**: Enable
3. **Index Document**: index.html
4. **Error Document**: 404.html
5. **Save**

## Paso 2: Configurar API Keys

### 2.1 Crear API Token
1. **API** → **Generate New Token**
2. **Scopes**: Spaces (Read/Write)
3. **Copiar** Access Key y Secret Key

### 2.2 Configurar localmente
```bash
# Instalar s3cmd
pip3 install s3cmd

# Configurar credenciales
s3cmd --configure

# Configuración interactiva:
# Access Key: TU_ACCESS_KEY
# Secret Key: TU_SECRET_KEY  
# Default Region: nyc3
# S3 Endpoint: nyc3.digitaloceanspaces.com
# DNS-style bucket: No
```

### 2.3 Archivo de configuración
```bash
# Crear ~/.s3cfg manualmente
cat > ~/.s3cfg << EOF
[default]
access_key = TU_ACCESS_KEY
secret_key = TU_SECRET_KEY
host_base = nyc3.digitaloceanspaces.com
host_bucket = %(bucket)s.nyc3.digitaloceanspaces.com
bucket_location = nyc3
use_https = True
signature_v2 = False
EOF
```

## Paso 3: Configurar GitHub Actions (Automático)

### 3.1 Agregar secrets al repositorio
1. **GitHub Repository** → **Settings** → **Secrets and variables** → **Actions**
2. **New repository secret**:
   ```
   SPACES_ACCESS_KEY: tu_access_key
   SPACES_SECRET_KEY: tu_secret_key
   DO_ACCESS_TOKEN: tu_do_api_token (para CDN)
   ```

### 3.2 Workflow ya configurado
- ✅ `.github/workflows/deploy-spaces.yml` ya creado
- ✅ Deploy automático en push a main
- ✅ Configuración de MIME types
- ✅ Headers de cache optimizados

## Paso 4: Deploy Manual (Primera vez)

### 4.1 Construir documentación
```bash
# En tu directorio local
mkdocs build --clean
```

### 4.2 Subir archivos usando script
```bash
# Hacer ejecutable el script
chmod +x deploy/spaces-setup.md

# Ejecutar upload
./deploy/spaces-setup.md
```

### 4.3 Upload manual con s3cmd
```bash
# Sync completo
s3cmd sync site/ s3://uneme-docs/ \
    --acl-public \
    --delete-removed \
    --guess-mime-type \
    --progress

# Verificar archivos
s3cmd ls s3://uneme-docs/
```

## Paso 5: Configurar CDN (Opcional pero Recomendado)

### 5.1 Habilitar CDN en Space
1. **Space** → **Settings** → **CDN**
2. **Enable CDN**
3. **Custom Subdomain**: docs-cdn.uneme-cecosama.com
4. **Certificate**: Let's Encrypt (automático)

### 5.2 Configurar TTL y Cache
```bash
# Configurar cache headers por tipo de archivo
# HTML - Cache corto (5 min)
s3cmd modify s3://uneme-docs/ \
    --add-header="Cache-Control:public, max-age=300" \
    --recursive --include="*.html"

# CSS/JS - Cache largo (1 año)
s3cmd modify s3://uneme-docs/ \
    --add-header="Cache-Control:public, max-age=31536000" \
    --recursive --include="*.css" --include="*.js"

# Imágenes - Cache muy largo
s3cmd modify s3://uneme-docs/ \
    --add-header="Cache-Control:public, max-age=31536000" \
    --recursive --include="*.png" --include="*.jpg" --include="*.svg"
```

## Paso 6: Configurar Dominio Personalizado

### 6.1 Configurar DNS
```bash
# En tu proveedor DNS:
# Tipo: CNAME
# Nombre: docs
# Valor: uneme-docs.nyc3.digitaloceanspaces.com
# O si usas CDN: tu-cdn-endpoint.b-cdn.net
```

### 6.2 SSL personalizado (si es necesario)
```bash
# Para dominios custom, configurar certificado
# En Space → Settings → SSL Certificate
# Upload certificate o usar Let's Encrypt
```

## Paso 7: Optimizaciones Avanzadas

### 7.1 Compresión Gzip
```bash
# Comprimir archivos antes de subir
find site -name "*.html" -o -name "*.css" -o -name "*.js" | \
while read file; do
    gzip -c "$file" > "$file.gz"
    s3cmd put "$file.gz" s3://uneme-docs/"${file#site/}" \
        --add-header="Content-Encoding:gzip" \
        --add-header="Cache-Control:public, max-age=31536000" \
        --acl-public
    rm "$file.gz"
done
```

### 7.2 Script de optimización
```bash
# Crear script optimize-upload.sh
cat > optimize-upload.sh << 'EOF'
#!/bin/bash

BUCKET="uneme-docs"
SITE_DIR="site"

# Build docs
mkdocs build --clean

# Optimize images (if needed)
if command -v optipng &> /dev/null; then
    find $SITE_DIR -name "*.png" -exec optipng -o7 {} \;
fi

# Upload with compression and optimization
s3cmd sync $SITE_DIR/ s3://$BUCKET/ \
    --acl-public \
    --delete-removed \
    --guess-mime-type \
    --add-header="X-Robots-Tag:noindex" \
    --progress

echo "✅ Upload completed with optimizations"
EOF

chmod +x optimize-upload.sh
```

## Paso 8: Monitoreo y Analytics

### 8.1 Configurar Access Logs
1. **Space** → **Settings** → **Access Logs**
2. **Enable Logging**
3. **Log Bucket**: crear bucket separado para logs

### 8.2 Monitoreo con doctl
```bash
# Instalar doctl CLI
curl -sL https://github.com/digitalocean/doctl/releases/download/v1.92.0/doctl-1.92.0-linux-amd64.tar.gz | tar -xzv
sudo mv doctl /usr/local/bin

# Autenticar
doctl auth init

# Ver estadísticas de Space
doctl compute space list
doctl compute space get uneme-docs
```

### 8.3 Script de monitoreo
```bash
# Crear monitor-spaces.sh
cat > monitor-spaces.sh << 'EOF'
#!/bin/bash

BUCKET="uneme-docs"
ENDPOINT="https://uneme-docs.nyc3.digitaloceanspaces.com"

# Check accessibility
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$ENDPOINT/")
if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ Site accessible"
else
    echo "❌ Site not accessible: $HTTP_STATUS"
fi

# Check space usage
USAGE=$(s3cmd du s3://$BUCKET/ | tail -1)
echo "📊 Space usage: $USAGE"

# Check recent files
echo "📁 Recent files:"
s3cmd ls s3://$BUCKET/ --recursive | tail -5
EOF

chmod +x monitor-spaces.sh
```

## Paso 9: Backup y Versionado

### 9.1 Configurar versionado
```bash
# Habilitar versionado en Space
s3cmd put-versioning s3://uneme-docs/ enable
```

### 9.2 Script de backup
```bash
# Crear backup-spaces.sh
cat > backup-spaces.sh << 'EOF'
#!/bin/bash

BUCKET="uneme-docs"
BACKUP_BUCKET="uneme-docs-backup"
DATE=$(date +%Y%m%d-%H%M%S)

# Create backup
s3cmd sync s3://$BUCKET/ s3://$BACKUP_BUCKET/$DATE/ --preserve

echo "✅ Backup created: s3://$BACKUP_BUCKET/$DATE/"
EOF

chmod +x backup-spaces.sh
```

## Paso 10: Troubleshooting

### 10.1 Problemas comunes
```bash
# Permisos incorrectos
s3cmd setacl s3://uneme-docs/ --acl-public --recursive

# MIME types incorrectos
s3cmd modify s3://uneme-docs/ \
    --add-header="Content-Type:text/html" \
    --recursive --include="*.html"

# Cache problems
s3cmd modify s3://uneme-docs/ \
    --remove-header="Cache-Control" \
    --recursive
```

### 10.2 Verificación de configuración
```bash
# Test S3 config
s3cmd info s3://uneme-docs/

# Test website access
curl -I https://uneme-docs.nyc3.digitaloceanspaces.com/

# Test CDN (si configurado)
curl -I https://tu-cdn-endpoint.b-cdn.net/
```

### 10.3 Logs de debug
```bash
# Ver logs detallados
s3cmd --debug sync site/ s3://uneme-docs/

# Ver configuración actual
s3cmd --dump-config
```

## Costos y Consideraciones

### Estructura de costos
```
Base: $5 USD/mes (250GB storage + 1TB transfer)
Overage: $0.02/GB storage adicional
Transfer: $0.01/GB adicional
CDN: Incluido sin costo extra
SSL: Incluido
```

### Estimación para UNEME
```
Documentación: ~100MB
Tráfico estimado: 10GB/mes
Costo total: $5 USD/mes
```

## URLs Finales

### URLs principales
- **Space Direct**: `https://uneme-docs.nyc3.digitaloceanspaces.com/`
- **CDN**: `https://tu-cdn-endpoint.b-cdn.net/`
- **Custom Domain**: `https://docs.uneme-cecosama.com/`

### Enlaces de gestión
- **Space Dashboard**: DigitalOcean → Spaces → uneme-docs
- **CDN Dashboard**: DigitalOcean → Networking → CDN
- **API Tokens**: DigitalOcean → API

---
*Configuración Spaces completa*  
*CDN global incluido*  
*Ideal para sitios con mucho tráfico*