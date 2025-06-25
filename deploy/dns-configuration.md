# DNS y Dominios - Configuración Universal

## Configuración para Todas las Plataformas

### Dominios Propuestos
- **Principal**: `docs.uneme-cecosama.com`
- **Staging**: `staging.docs.uneme-cecosama.com`
- **CDN**: `cdn.docs.uneme-cecosama.com`
- **API**: `api.docs.uneme-cecosama.com` (futuro)

## Configuración por Proveedor DNS

### Cloudflare (Recomendado)

#### Ventajas
- ✅ CDN gratuito integrado
- ✅ SSL automático
- ✅ DDoS protection
- ✅ Analytics incluidos
- ✅ DNS rápido global

#### Configuración
```bash
# Registros DNS en Cloudflare
Name: docs
Type: CNAME
Content: TU-USUARIO.github.io  # Para GitHub Pages
TTL: Auto
Proxy: ✅ Proxied (Orange Cloud)

Name: staging
Type: CNAME  
Content: uneme-docs.nyc3.digitaloceanspaces.com  # Para Spaces
TTL: Auto
Proxy: ✅ Proxied

Name: app
Type: CNAME
Content: uneme-cecosama-docs-xxxxx.ondigitalocean.app  # Para App Platform
TTL: Auto
Proxy: ❌ DNS Only (Gray Cloud)
```

#### Page Rules para optimización
```bash
# Regla 1: Cache everything
URL: docs.uneme-cecosama.com/*
Settings:
  - Cache Level: Cache Everything
  - Edge Cache TTL: 1 month
  - Browser Cache TTL: 4 hours

# Regla 2: Security headers
URL: docs.uneme-cecosama.com/*
Settings:
  - Security Level: Medium
  - SSL: Full (strict)
  - Always Use HTTPS: On
```

### DigitalOcean DNS

#### Configuración en DigitalOcean
```bash
# En DigitalOcean Dashboard → Networking → Domains
Domain: uneme-cecosama.com

# Registros DNS
docs    CNAME   TU-USUARIO.github.io                         300
staging CNAME   uneme-docs.nyc3.digitaloceanspaces.com       300
app     CNAME   uneme-cecosama-docs-xxxxx.ondigitalocean.app  300
cdn     CNAME   your-cdn-endpoint.b-cdn.net                   3600

# Si usas Droplet
droplet A       YOUR_DROPLET_IP                               300
```

### Namecheap / GoDaddy / Registro Tradicional

#### Configuración básica
```bash
# Advanced DNS en tu proveedor
Type    Host    Value                                         TTL
CNAME   docs    TU-USUARIO.github.io                         300
CNAME   staging uneme-docs.nyc3.digitaloceanspaces.com       300
CNAME   app     uneme-cecosama-docs-xxxxx.ondigitalocean.app  300
A       droplet YOUR_DROPLET_IP                               300
```

## Configuración por Plataforma

### 1. GitHub Pages

#### Configuración automática
```bash
# Crear archivo CNAME en docs/
echo "docs.uneme-cecosama.com" > docs/CNAME
git add docs/CNAME
git commit -m "Add custom domain"
git push origin main
```

#### Verificación en GitHub
1. **Repository** → **Settings** → **Pages**
2. **Custom domain**: `docs.uneme-cecosama.com`
3. **Enforce HTTPS**: ✅ Enabled
4. Esperar verificación DNS (~5-10 min)

#### Troubleshooting GitHub Pages
```bash
# Verificar propagación DNS
dig docs.uneme-cecosama.com CNAME

# Verificar desde GitHub
curl -I https://docs.uneme-cecosama.com

# Ver logs de GitHub Pages
# Repository → Settings → Pages → Ver errores
```

### 2. DigitalOcean App Platform

#### Configurar dominio en App Platform
1. **App** → **Settings** → **Domains**
2. **Add Domain**: `app.docs.uneme-cecosama.com`
3. **Type**: Primary
4. **SSL**: Managed Certificate (automático)

#### Configuración manual con doctl
```bash
# Usando CLI de DigitalOcean
doctl apps create-domain uneme-cecosama-docs app.docs.uneme-cecosama.com
doctl apps list-domains uneme-cecosama-docs
```

### 3. DigitalOcean Spaces

#### Configurar CDN para Spaces
1. **Spaces** → **uneme-docs** → **Settings** → **CDN**
2. **Enable CDN**
3. **Custom Subdomain**: `cdn.docs.uneme-cecosama.com`
4. **Certificate**: Let's Encrypt

#### Configuración manual
```bash
# Crear CDN endpoint
doctl compute cdn create --origin uneme-docs.nyc3.digitaloceanspaces.com --custom-domain cdn.docs.uneme-cecosama.com

# Verificar CDN
curl -I https://cdn.docs.uneme-cecosama.com
```

### 4. Droplet Personalizado

#### Configurar Nginx para múltiples dominios
```nginx
# /etc/nginx/sites-available/uneme-docs
server {
    listen 80;
    server_name docs.uneme-cecosama.com droplet.docs.uneme-cecosama.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name docs.uneme-cecosama.com droplet.docs.uneme-cecosama.com;
    
    # SSL configuration
    ssl_certificate /etc/letsencrypt/live/docs.uneme-cecosama.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/docs.uneme-cecosama.com/privkey.pem;
    
    # Content configuration
    root /var/www/uneme-docs/site;
    index index.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
```

#### Obtener certificado SSL
```bash
# Certificado para múltiples dominios
certbot --nginx -d docs.uneme-cecosama.com -d droplet.docs.uneme-cecosama.com

# Verificar auto-renovación
certbot renew --dry-run
```

## Configuración de Staging/Testing

### Subdominio de Staging
```bash
# DNS para staging
staging.docs.uneme-cecosama.com → uneme-docs-staging.nyc3.digitaloceanspaces.com
test.docs.uneme-cecosama.com    → test-deploy-branch.github.io
dev.docs.uneme-cecosama.com     → local-development-server
```

### Workflow para Staging
```yaml
# .github/workflows/deploy-staging.yml
name: Deploy Staging
on:
  push:
    branches: [ develop, staging ]

jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to staging
        run: |
          mkdocs build
          s3cmd sync site/ s3://uneme-docs-staging/ --acl-public
```

## Monitoreo DNS

### Script de verificación DNS
```bash
#!/bin/bash
# dns-check.sh

DOMAINS=(
    "docs.uneme-cecosama.com"
    "staging.docs.uneme-cecosama.com"
    "app.docs.uneme-cecosama.com"
    "cdn.docs.uneme-cecosama.com"
)

echo "🔍 Verificando configuración DNS..."

for domain in "${DOMAINS[@]}"; do
    echo ""
    echo "Checking: $domain"
    echo "----------------------------------------"
    
    # Check A/CNAME record
    dig +short "$domain" | head -1
    
    # Check HTTPS
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://$domain" --max-time 10)
    if [ "$HTTP_STATUS" = "200" ]; then
        echo "✅ HTTPS: OK ($HTTP_STATUS)"
    else
        echo "❌ HTTPS: Failed ($HTTP_STATUS)"
    fi
    
    # Check SSL certificate
    SSL_EXPIRY=$(echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
    if [ -n "$SSL_EXPIRY" ]; then
        echo "🔒 SSL: Valid until $SSL_EXPIRY"
    else
        echo "❌ SSL: Certificate issue"
    fi
done
```

### Monitoreo automatizado
```bash
# Crear cron job para verificación diaria
echo "0 9 * * * /path/to/dns-check.sh > /var/log/dns-check.log 2>&1" | crontab -
```

## Load Balancing y Failover

### Configuración de Cloudflare Load Balancer
```javascript
// Cloudflare Load Balancer configuration
{
  "pools": [
    {
      "name": "github-pages",
      "origins": [
        {
          "name": "github",
          "address": "TU-USUARIO.github.io",
          "enabled": true,
          "weight": 1
        }
      ],
      "monitor": "health-check"
    },
    {
      "name": "app-platform",
      "origins": [
        {
          "name": "digitalocean-app",
          "address": "uneme-cecosama-docs-xxxxx.ondigitalocean.app",
          "enabled": true,
          "weight": 1
        }
      ],
      "monitor": "health-check"
    }
  ],
  "rules": [
    {
      "name": "default-rule",
      "pools": ["github-pages", "app-platform"],
      "region": "WNAM"
    }
  ]
}
```

### Health Checks
```bash
# Health check endpoints
https://docs.uneme-cecosama.com/health
https://app.docs.uneme-cecosama.com/health
https://cdn.docs.uneme-cecosama.com/health
```

## Optimizaciones de Performance

### TTL Optimization
```bash
# TTL settings por tipo de content
HTML files:    300 seconds   (5 minutes)
CSS/JS files:  86400 seconds (24 hours)
Images:        604800 seconds (7 days)
Fonts:         2592000 seconds (30 days)
```

### Cache Headers por plataforma
```bash
# GitHub Pages (automático)
Cache-Control: max-age=600

# Spaces (configurable)
Cache-Control: public, max-age=31536000

# App Platform (configurable via headers)
Cache-Control: public, max-age=3600

# Droplet (Nginx configuration)
location ~* \.(css|js)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

## Troubleshooting DNS

### Comandos de diagnóstico
```bash
# Verificar propagación DNS global
dig @8.8.8.8 docs.uneme-cecosama.com
dig @1.1.1.1 docs.uneme-cecosama.com

# Verificar desde diferentes regiones
nslookup docs.uneme-cecosama.com 8.8.8.8
nslookup docs.uneme-cecosama.com 1.1.1.1

# Trace DNS resolution
dig +trace docs.uneme-cecosama.com

# Check DNSSEC
dig +dnssec docs.uneme-cecosama.com
```

### Herramientas online
- **DNS Checker**: https://dnschecker.org/
- **DNS Propagation**: https://www.whatsmydns.net/
- **SSL Checker**: https://www.ssllabs.com/ssltest/

### Problemas comunes

#### 1. DNS no propaga
```bash
# Verificar TTL
dig docs.uneme-cecosama.com | grep TTL

# Limpiar cache DNS local
sudo dscacheutil -flushcache  # macOS
sudo systemctl restart systemd-resolved  # Linux
```

#### 2. SSL Certificate issues
```bash
# Verificar cadena de certificados
openssl s_client -servername docs.uneme-cecosama.com -connect docs.uneme-cecosama.com:443

# Verificar expiración
echo | openssl s_client -servername docs.uneme-cecosama.com -connect docs.uneme-cecosama.com:443 2>/dev/null | openssl x509 -noout -dates
```

#### 3. Mixed content warnings
```bash
# Verificar recursos HTTPS
curl -s https://docs.uneme-cecosama.com | grep -i "http://"

# Fix en mkdocs.yml
site_url: 'https://docs.uneme-cecosama.com'
use_directory_urls: true
```

## Resumen de URLs Finales

| Propósito | URL | Plataforma |
|-----------|-----|------------|
| **Principal** | https://docs.uneme-cecosama.com | GitHub Pages |
| **Staging** | https://staging.docs.uneme-cecosama.com | Spaces |
| **App Platform** | https://app.docs.uneme-cecosama.com | App Platform |
| **CDN** | https://cdn.docs.uneme-cecosama.com | Spaces + CDN |
| **Droplet** | https://droplet.docs.uneme-cecosama.com | Droplet |
| **Development** | http://localhost:8000 | Local |

---
*Configuración DNS completa*  
*Multi-platform con failover*  
*SSL y performance optimizado*