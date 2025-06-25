# DigitalOcean App Platform - Configuración Completa

## Paso 1: Preparar Repositorio GitHub

### 1.1 Crear repositorio
```bash
# Inicializar git (si no está ya)
git init
git add .
git commit -m "Documentación UNEME-CECOSAMA inicial"

# Crear repositorio en GitHub
# Nombrar: uneme-cecosama-docs

# Conectar y subir
git remote add origin https://github.com/TU-USUARIO/uneme-cecosama-docs.git
git branch -M main
git push -u origin main
```

### 1.2 Verificar archivos clave
- ✅ `mkdocs.yml` - Configuración MkDocs
- ✅ `requirements.txt` - Dependencias Python
- ✅ `.do/app.yaml` - Configuración App Platform
- ✅ `docs/` - Carpeta con documentación

## Paso 2: Crear App en DigitalOcean

### 2.1 Desde Dashboard Web
1. **Ir a App Platform**: https://cloud.digitalocean.com/apps
2. **Create App** → **GitHub**
3. **Autorizar DigitalOcean** en GitHub
4. **Seleccionar repositorio**: `uneme-cecosama-docs`
5. **Seleccionar rama**: `main`
6. **Auto-detect**: Detectará Python automáticamente

### 2.2 Configuración automática
```yaml
# App Platform detectará automáticamente:
Source: GitHub Repository
Branch: main
Autodeploy: Enabled
Build Command: pip install -r requirements.txt && mkdocs build
Run Command: python -m http.server 8080 --directory site
```

### 2.3 Configuración manual (si es necesaria)
```bash
# Si auto-detect falla, configurar manualmente:
Environment: Python
Build Command: pip install -r requirements.txt && mkdocs build
Run Command: python -m http.server 8080 --directory site
HTTP Port: 8080
```

## Paso 3: Configurar Dominio Personalizado

### 3.1 Esperar deployment inicial
- ✅ Primera build: ~5-10 minutos
- ✅ URL temporal: `uneme-cecosama-docs-xxxxx.ondigitalocean.app`

### 3.2 Agregar dominio personalizado
1. **App Settings** → **Domains**
2. **Add Domain**: `docs.uneme-cecosama.com`
3. **Type**: Primary
4. **SSL**: Auto-enabled

### 3.3 Configurar DNS
```bash
# En tu proveedor de DNS (ej: Cloudflare, Namecheap)
# Agregar registro CNAME:
Name: docs
Value: uneme-cecosama-docs-xxxxx.ondigitalocean.app
TTL: 300 (5 min)
```

## Paso 4: Configurar Variables de Entorno

### 4.1 Variables opcionales
```yaml
# En App Platform → Settings → Environment Variables
MKDOCS_CONFIG_FILE: "mkdocs.yml"
PYTHONPATH: "."
ENVIRONMENT: "production"
```

## Paso 5: Configurar Auto-Deploy

### 5.1 GitHub Webhook (automático)
- ✅ Se configura automáticamente
- ✅ Push a `main` = Deploy automático
- ✅ Pull Request = Preview deploy

### 5.2 Verificar webhook
1. **GitHub** → **Settings** → **Webhooks**
2. Verificar webhook de DigitalOcean

## Paso 6: Monitoreo y Logs

### 6.1 Runtime Logs
```bash
# Ver logs en tiempo real
# App Platform → Runtime Logs
# Build Logs para debugging
```

### 6.2 Métricas
```yaml
# Disponibles automáticamente:
- CPU Usage
- Memory Usage  
- HTTP Requests
- Response Times
- Error Rate
```

## Paso 7: Configuración Avanzada

### 7.1 Auto-scaling
```yaml
# Ya configurado en .do/app.yaml
scaling:
  min_instance_count: 1
  max_instance_count: 3
```

### 7.2 Health Checks
```yaml
# Ya configurado
health_check:
  http_path: /
  initial_delay_seconds: 30
  period_seconds: 10
```

## Comandos de Gestión

### Actualizar documentación
```bash
# 1. Editar archivos markdown en docs/
# 2. Commit y push
git add .
git commit -m "Actualizar documentación formulario X"
git push origin main

# 3. Deploy automático en ~2-3 minutos
```

### Ver estado del deploy
```bash
# Usar CLI de DigitalOcean (opcional)
doctl apps list
doctl apps get uneme-cecosama-docs
doctl apps logs uneme-cecosama-docs
```

## Solución de Problemas

### Build falla
```bash
# Verificar requirements.txt
# Verificar mkdocs.yml syntax
# Ver Build Logs en Dashboard
```

### Dominio no funciona
```bash
# Verificar DNS propagation
dig docs.uneme-cecosama.com

# Verificar SSL certificate
curl -I https://docs.uneme-cecosama.com
```

### Performance Issues
```bash
# Aumentar instance size
# App Platform → Settings → Resources
# Cambiar de basic-xxs a professional-xs
```

## Costos Estimados

| Configuración | Costo/Mes |
|---------------|-----------|
| Basic (actual) | $5 USD |
| Professional | $12 USD |
| Con dominio | +$0 USD |
| SSL | +$0 USD |

---
*Configuración lista para producción*  
*URL temporal: Disponible tras primer deploy*  
*URL final: https://docs.uneme-cecosama.com*