# UNEME-CECOSAMA Documentation - Deployment Guide

## 🚀 Todas las Opciones de Deployment Configuradas

Esta documentación está configurada para desplegarse en **TODAS** las principales plataformas de hosting, proporcionando redundancia, flexibilidad y opciones para diferentes necesidades.

## 📋 Opciones Disponibles

| Plataforma | Costo | Dificultad | Características |
|------------|-------|------------|-----------------|
| **🔶 DigitalOcean App Platform** | $5/mes | Fácil | Auto-deploy, SSL, Escalable |
| **🌊 GitHub Pages** | Gratis | Fácil | SSL automático, CI/CD integrado |
| **☁️ DigitalOcean Spaces** | $5/mes | Medio | CDN global, S3-compatible |
| **🖥️ Droplet + Nginx** | $6/mes | Avanzado | Control total, Personalizable |

## 🎯 Recomendaciones por Caso de Uso

### Para Empezar (Gratis)
```bash
✅ GitHub Pages
- Configuración: 5 minutos
- Costo: $0/mes
- URL: https://tu-usuario.github.io/uneme-cecosama-docs/
```

### Para Producción (Fácil)
```bash
✅ DigitalOcean App Platform
- Configuración: 10 minutos
- Costo: $5/mes
- Auto-scaling incluido
- SSL automático
```

### Para Alto Tráfico (Performance)
```bash
✅ DigitalOcean Spaces + CDN
- Configuración: 15 minutos
- Costo: $5/mes
- CDN global incluido
- S3-compatible
```

### Para Control Total (Avanzado)
```bash
✅ Droplet + Nginx
- Configuración: 30 minutos
- Costo: $6/mes
- Control completo del servidor
- Customización avanzada
```

## 🚀 Quick Start (5 minutos)

### Opción 1: Script Automático
```bash
# Descargar y ejecutar script de configuración rápida
chmod +x deploy/quick-deploy.sh
./deploy/quick-deploy.sh
```

### Opción 2: GitHub Pages (Manual)
```bash
# 1. Fork/clone este repositorio
git clone https://github.com/TU-USUARIO/uneme-cecosama-docs.git
cd uneme-cecosama-docs

# 2. Habilitar GitHub Pages
# GitHub → Settings → Pages → Source: Deploy from branch → gh-pages

# 3. Push para activar deploy automático
git push origin main

# 4. Acceder en ~2 minutos
# https://TU-USUARIO.github.io/uneme-cecosama-docs/
```

## 📁 Estructura de Archivos de Deployment

```
deploy/
├── README.md                    # Esta guía
├── quick-deploy.sh             # 🚀 Script de inicio rápido
├── deploy-all.sh              # 🔧 Script completo universal
├── config.env                 # ⚙️ Configuración central
├── app-platform-setup.md      # 🔶 Guía App Platform
├── github-pages-setup.md      # 🌊 Guía GitHub Pages
├── spaces-manual.md           # ☁️ Guía Spaces + CDN
├── droplet-setup.sh           # 🖥️ Script Droplet automático
├── droplet-manual.md          # 🖥️ Guía Droplet manual
├── dns-configuration.md       # 🌐 Configuración DNS
└── spaces-setup.md           # ☁️ Script Spaces
```

## 🎛️ Workflows Automatizados

### GitHub Actions Configurados
```
.github/workflows/
├── deploy-docs.yml         # 🌊 GitHub Pages auto-deploy
├── test-build.yml          # 🧪 Testing automático
└── deploy-spaces.yml       # ☁️ Spaces auto-deploy
```

### Features de CI/CD
- ✅ **Auto-build** en cada push a main
- ✅ **Testing** en Pull Requests
- ✅ **Multi-platform deploy** simultáneo
- ✅ **Cache optimization** para builds rápidos
- ✅ **Notificaciones** de estado
- ✅ **Rollback automático** en fallos

## 🌐 Dominios y DNS

### Dominios Configurados
- **Principal**: `docs.uneme-cecosama.com`
- **Staging**: `staging.docs.uneme-cecosama.com`
- **CDN**: `cdn.docs.uneme-cecosama.com`
- **App**: `app.docs.uneme-cecosama.com`

### SSL Incluido
- ✅ Let's Encrypt automático
- ✅ Renovación automática
- ✅ HTTPS forzado
- ✅ HSTS headers

## 📊 Comparación Detallada

### Performance
| Plataforma | Build Time | Deploy Time | SSL | CDN |
|------------|------------|-------------|-----|-----|
| GitHub Pages | 2-3 min | Automático | ✅ | GitHub CDN |
| App Platform | 1-2 min | Automático | ✅ | DO CDN |
| Spaces | Instantáneo | 30 seg | ✅ | Global CDN |
| Droplet | Instantáneo | 10 seg | Manual | Opcional |

### Costos Mensuales
```
GitHub Pages:    $0    (repo público)
App Platform:    $5    (plan básico)
Spaces + CDN:    $5    (250GB + 1TB transfer)
Droplet:         $6    (1GB RAM, 25GB SSD)
```

### Límites
```
GitHub Pages:    1GB repo, 100GB/mes ancho de banda
App Platform:    Sin límites de tráfico
Spaces:          Ilimitado con CDN
Droplet:         Solo limitado por recursos del servidor
```

## 🔧 Configuración Avanzada

### Variables de Entorno
```bash
# GitHub Secrets necesarios
SPACES_ACCESS_KEY=tu_access_key
SPACES_SECRET_KEY=tu_secret_key
DO_ACCESS_TOKEN=tu_do_token
```

### Customización
```bash
# Editar configuración
nano deploy/config.env

# Configurar notificaciones
SLACK_WEBHOOK="https://hooks.slack.com/..."
EMAIL_NOTIFICATION="admin@uneme-cecosama.com"

# Configurar dominios personalizados
CUSTOM_DOMAIN="docs.uneme-cecosama.com"
```

## 🚨 Troubleshooting

### Problemas Comunes

#### Build falla
```bash
# Verificar mkdocs.yml syntax
mkdocs build --verbose

# Verificar dependencias
pip install -r requirements.txt
```

#### DNS no resuelve
```bash
# Verificar propagación
dig docs.uneme-cecosama.com

# Verificar TTL
dig docs.uneme-cecosama.com | grep TTL
```

#### SSL no funciona
```bash
# Verificar certificado
curl -I https://docs.uneme-cecosama.com

# GitHub Pages: esperar 24-48h para certificado
# App Platform: automático
# Droplet: ejecutar certbot
```

### Logs de Debug
```bash
# Ver logs de build
cat logs/build.log

# Ver logs de deploy
cat logs/deploy.log

# GitHub Actions logs
# GitHub → Actions → Ver workflow
```

## 📱 Monitoreo

### Health Checks Configurados
```bash
# URLs de health check
https://docs.uneme-cecosama.com/
https://app.docs.uneme-cecosama.com/
https://cdn.docs.uneme-cecosama.com/
```

### Scripts de Monitoreo
```bash
# Verificar todos los deployments
./deploy/test-deployments.sh

# Verificar DNS
./deploy/dns-check.sh

# Monitoreo continuo
./deploy/monitor-all.sh
```

## 🔄 Workflow de Actualización

### Proceso Normal
```bash
1. Editar archivos markdown en docs/
2. git add . && git commit -m "Update docs"
3. git push origin main
4. Auto-deploy se ejecuta en ~2-3 minutos
5. Verificar en todas las URLs
```

### Proceso con Script Universal
```bash
# Deploy a todas las plataformas simultáneamente
./deploy/deploy-all.sh

# Solo build local
./deploy/deploy-all.sh --build-only

# Solo testing
./deploy/deploy-all.sh --test-only
```

## 🏁 Estado Actual

### ✅ Configurado y Listo
- [x] **GitHub Pages** con Actions
- [x] **App Platform** con auto-deploy
- [x] **Spaces** con CDN
- [x] **Droplet** con Nginx + SSL
- [x] **DNS** multi-plataforma
- [x] **Scripts** automatizados
- [x] **Monitoreo** incluido

### 🎯 URLs de Acceso
Una vez configurado, la documentación estará disponible en:

1. **https://tu-usuario.github.io/uneme-cecosama-docs/** (GitHub Pages)
2. **https://docs.uneme-cecosama.com** (Dominio personalizado)
3. **https://app.docs.uneme-cecosama.com** (App Platform)
4. **https://cdn.docs.uneme-cecosama.com** (Spaces + CDN)

---

## 💡 Próximos Pasos

1. **Elegir plataforma** según tus necesidades
2. **Seguir la guía** específica de la plataforma elegida
3. **Configurar dominio** personalizado (opcional)
4. **Activar monitoreo** (recomendado)
5. **Empezar a documentar** los formularios restantes

¿Necesitas ayuda con alguna configuración específica? Cada archivo en `/deploy/` tiene instrucciones detalladas paso a paso.

**¡La documentación de UNEME-CECOSAMA está lista para ser desplegada en cualquier plataforma!** 🎉