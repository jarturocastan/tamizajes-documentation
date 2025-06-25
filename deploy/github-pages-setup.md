# GitHub Pages - Configuración Completa

## Opción Gratuita con GitHub Pages

### Ventajas
- ✅ **Gratis** para repositorios públicos
- ✅ **SSL automático** (.github.io)
- ✅ **CI/CD integrado** con GitHub Actions
- ✅ **Fácil configuración**
- ✅ **Dominio personalizado** gratuito

### Limitaciones
- ⚠️ Solo repositorios públicos (gratis)
- ⚠️ Límite de 1GB por repositorio
- ⚠️ Límite de 100GB ancho de banda/mes
- ⚠️ Solo sitios estáticos

## Paso 1: Preparar Repositorio

### 1.1 Estructura necesaria
```
uneme-cecosama-docs/
├── .github/
│   └── workflows/
│       ├── deploy-docs.yml     ✅ Ya creado
│       └── test-build.yml      ✅ Ya creado
├── docs/                       ✅ Ya existe
├── mkdocs.yml                  ✅ Ya existe
├── requirements.txt            ✅ Ya existe
└── README.md
```

### 1.2 Verificar archivos
```bash
# Verificar que los archivos estén presentes
ls -la .github/workflows/
ls -la docs/
ls mkdocs.yml requirements.txt
```

## Paso 2: Configurar GitHub Pages

### 2.1 Habilitar GitHub Pages
1. **GitHub Repository** → **Settings**
2. **Pages** (en sidebar izquierdo)
3. **Source**: Deploy from a branch
4. **Branch**: gh-pages (se creará automáticamente)
5. **Folder**: / (root)
6. **Save**

### 2.2 Configuración automática con Actions
```yaml
# Ya configurado en .github/workflows/deploy-docs.yml
# Se ejecuta automáticamente en cada push a main
```

## Paso 3: Configurar MkDocs para GitHub Pages

### 3.1 Actualizar mkdocs.yml
```yaml
# Agregar configuración específica para GitHub Pages
site_url: 'https://TU-USUARIO.github.io/uneme-cecosama-docs/'
site_name: 'UNEME-CECOSAMA Documentation'

# Configuración para GitHub Pages
use_directory_urls: true
edit_uri: 'edit/main/docs/'

# Plugin git para mostrar fechas de edición
plugins:
  - search
  - git-revision-date-localized:
      type: date
      locale: es

# Configuración adicional para GitHub
repo_url: 'https://github.com/TU-USUARIO/uneme-cecosama-docs'
repo_name: 'TU-USUARIO/uneme-cecosama-docs'
```

### 3.2 Configurar dominio personalizado (opcional)
```bash
# Crear archivo CNAME en docs/
echo "docs.uneme-cecosama.com" > docs/CNAME
```

## Paso 4: Automatización Completa

### 4.1 Workflow principal (deploy-docs.yml)
```yaml
# Features del workflow:
✅ Build automático en cada push
✅ Deploy a GitHub Pages
✅ Notificación de estado
✅ Cache para dependencias
✅ Soporte para múltiples ramas
```

### 4.2 Workflow de testing (test-build.yml)
```yaml
# Features del workflow de testing:
✅ Test en múltiples versiones de Python
✅ Verificación de links rotos
✅ Lint de archivos markdown
✅ Artifacts de debug en fallos
✅ Reportes automáticos
```

## Paso 5: Primera Implementación

### 5.1 Subir código a GitHub
```bash
# Inicializar git si no está
git init

# Agregar archivos
git add .
git commit -m "Configuración inicial documentación UNEME-CECOSAMA"

# Conectar con GitHub
git remote add origin https://github.com/TU-USUARIO/uneme-cecosama-docs.git
git branch -M main
git push -u origin main
```

### 5.2 Verificar deployment
1. **GitHub** → **Actions** → Ver workflow ejecutándose
2. **Esperar** ~2-5 minutos para completar
3. **Verificar** en `https://TU-USUARIO.github.io/uneme-cecosama-docs/`

## Paso 6: Configurar Dominio Personalizado

### 6.1 Agregar CNAME al repositorio
```bash
# Crear archivo CNAME
echo "docs.uneme-cecosama.com" > docs/CNAME
git add docs/CNAME
git commit -m "Agregar dominio personalizado"
git push origin main
```

### 6.2 Configurar DNS
```bash
# En tu proveedor de DNS (ej: Cloudflare, Namecheap):
# Tipo: CNAME
# Nombre: docs
# Valor: TU-USUARIO.github.io
# TTL: 300 (5 min)
```

### 6.3 Verificar en GitHub
1. **Repository** → **Settings** → **Pages**
2. **Custom domain**: docs.uneme-cecosama.com
3. **Enforce HTTPS**: ✓ (habilitado automáticamente)

## Paso 7: Configuraciones Avanzadas

### 7.1 Múltiples environments
```yaml
# Crear .github/workflows/deploy-staging.yml para staging
name: Deploy to Staging
on:
  push:
    branches: [ develop ]

jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    steps:
      # Similar al deploy principal pero con otro dominio
      - name: Deploy to staging
        run: |
          # Deploy a staging.docs.uneme-cecosama.com
```

### 7.2 Pull Request previews
```yaml
# Ya incluido en test-build.yml
# Cada PR genera un preview build sin deploy
```

### 7.3 Analytics y monitoreo
```yaml
# Agregar a mkdocs.yml
extra:
  analytics:
    provider: google
    property: G-XXXXXXXXXX  # Tu Google Analytics ID
    
  # Configurar feedback
  feedback:
    title: ¿Fue útil esta página?
    ratings:
      - icon: material/thumb-up-outline
        name: Esta página me fue útil
        data: 1
        note: >-
          ¡Gracias por tu feedback!
      - icon: material/thumb-down-outline
        name: Esta página puede mejorar
        data: 0
        note: >-
          Gracias por el feedback. <a href="..." target="_blank" rel="noopener">Cuéntanos cómo podemos mejorar</a>.
```

## Paso 8: Mantenimiento y Actualizaciones

### 8.1 Workflow para actualizaciones
```bash
# Proceso normal de actualización:
1. Editar archivos markdown en docs/
2. git add . && git commit -m "Actualizar documentación"
3. git push origin main
4. GitHub Actions se ejecuta automáticamente
5. Sitio actualizado en ~2-3 minutos
```

### 8.2 Monitoreo de builds
```bash
# Ver estado de deployments
# GitHub → Actions → Ver workflows
# GitHub → Environments → Ver deployments activos
```

### 8.3 Rollback en caso de problemas
```bash
# Rollback a commit anterior
git revert HEAD
git push origin main

# O deploy de rama específica
git checkout COMMIT_ANTERIOR
git push origin main --force  # ¡Cuidado con --force!
```

## Paso 9: Optimizaciones

### 9.1 Cache y performance
```yaml
# Ya incluido en workflows:
- uses: actions/setup-python@v4
  with:
    cache: 'pip'  # Cache de dependencias

# Optimizar build con cache
- name: Cache MkDocs build
  uses: actions/cache@v3
  with:
    path: .cache
    key: mkdocs-${{ github.sha }}
    restore-keys: mkdocs-
```

### 9.2 Compresión de assets
```yaml
# Agregar a mkdocs.yml
plugins:
  - search
  - minify:
      minify_html: true
      minify_js: true
      minify_css: true
      htmlmin_opts:
        remove_comments: true
```

## Paso 10: Troubleshooting

### 10.1 Build falla
```bash
# Verificar logs en GitHub Actions
# Común: error en mkdocs.yml syntax
# Común: dependencias faltantes en requirements.txt
# Común: archivos markdown con errores
```

### 10.2 Dominio personalizado no funciona
```bash
# Verificar DNS propagation
nslookup docs.uneme-cecosama.com

# Verificar archivo CNAME
cat docs/CNAME

# Verificar configuración en GitHub Pages settings
```

### 10.3 SSL no funciona
```bash
# GitHub Pages SSL es automático para dominios .github.io
# Para dominios personalizados, puede tomar 24-48h
# Verificar en Repository → Settings → Pages → HTTPS
```

## Comparación con Otras Opciones

| Característica | GitHub Pages | App Platform | Droplet |
|----------------|--------------|--------------|---------|
| **Costo** | Gratis | $5/mes | $6/mes |
| **Setup** | Fácil | Fácil | Medio |
| **Control** | Limitado | Medio | Total |
| **SSL** | Automático | Automático | Manual |
| **Custom Domain** | Sí | Sí | Sí |
| **Build Time** | 2-3 min | 1-2 min | Inmediato |
| **Uptime** | 99.9%+ | 99.9%+ | Depends |

## URLs Finales

### URLs de desarrollo
- **Temporal**: `https://TU-USUARIO.github.io/uneme-cecosama-docs/`
- **Con dominio**: `https://docs.uneme-cecosama.com`
- **Staging**: `https://staging.docs.uneme-cecosama.com` (opcional)

### Enlaces útiles
- **Repository**: `https://github.com/TU-USUARIO/uneme-cecosama-docs`
- **Actions**: `https://github.com/TU-USUARIO/uneme-cecosama-docs/actions`
- **Settings**: `https://github.com/TU-USUARIO/uneme-cecosama-docs/settings/pages`

---
*Configuración GitHub Pages completa*  
*Gratis y automático*  
*Ideal para documentación pública*