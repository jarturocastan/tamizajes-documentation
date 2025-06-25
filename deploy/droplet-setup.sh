#!/bin/bash

# UNEME-CECOSAMA Documentation - Droplet Setup Script
# Para Ubuntu 22.04 LTS

set -e  # Exit on any error

echo "🚀 Iniciando configuración del servidor para documentación UNEME-CECOSAMA..."

# Variables de configuración
DOMAIN="docs.uneme-cecosama.com"
REPO_URL="https://github.com/TU-USUARIO/uneme-cecosama-docs.git"
SITE_PATH="/var/www/uneme-docs"
NGINX_CONFIG="/etc/nginx/sites-available/uneme-docs"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Función para verificar si comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 1. Actualizar sistema
print_status "Actualizando sistema..."
apt update && apt upgrade -y

# 2. Instalar dependencias básicas
print_status "Instalando dependencias básicas..."
apt install -y \
    curl \
    wget \
    git \
    nano \
    htop \
    ufw \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# 3. Instalar Python y pip
print_status "Instalando Python y pip..."
apt install -y python3 python3-pip python3-venv

# 4. Instalar Nginx
print_status "Instalando Nginx..."
apt install -y nginx

# 5. Configurar firewall
print_status "Configurando firewall..."
ufw --force enable
ufw allow ssh
ufw allow 'Nginx Full'
ufw allow 80
ufw allow 443

# 6. Instalar MkDocs y dependencias
print_status "Instalando MkDocs..."
pip3 install mkdocs mkdocs-material mkdocs-awesome-pages-plugin mkdocs-mermaid2-plugin pymdown-extensions mkdocs-minify-plugin

# 7. Crear directorio del sitio
print_status "Creando directorio del sitio..."
mkdir -p $SITE_PATH
cd $SITE_PATH

# 8. Clonar repositorio
print_status "Clonando repositorio de documentación..."
if [ -d "$SITE_PATH/.git" ]; then
    print_warning "Repositorio ya existe, actualizando..."
    git pull origin main
else
    git clone $REPO_URL .
fi

# 9. Construir documentación
print_status "Construyendo documentación..."
mkdocs build

# 10. Configurar Nginx
print_status "Configurando Nginx..."
cat > $NGINX_CONFIG << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    
    # Redirect HTTP to HTTPS
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN www.$DOMAIN;
    
    # SSL Configuration (placeholder for Let's Encrypt)
    # ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    # ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;
    
    # Document root
    root $SITE_PATH/site;
    index index.html;
    
    # Main location
    location / {
        try_files \$uri \$uri/ =404;
        
        # Cache static assets
        location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
    
    # Security: hide sensitive files
    location ~ /\. {
        deny all;
    }
    
    location ~ /(mkdocs.yml|requirements.txt|\.git) {
        deny all;
    }
    
    # Custom error pages
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    
    # Access and error logs
    access_log /var/log/nginx/$DOMAIN.access.log;
    error_log /var/log/nginx/$DOMAIN.error.log;
}
EOF

# 11. Habilitar sitio
print_status "Habilitando sitio en Nginx..."
ln -sf $NGINX_CONFIG /etc/nginx/sites-enabled/

# Deshabilitar sitio default si existe
if [ -f "/etc/nginx/sites-enabled/default" ]; then
    rm /etc/nginx/sites-enabled/default
fi

# 12. Verificar configuración de Nginx
print_status "Verificando configuración de Nginx..."
nginx -t

# 13. Reiniciar Nginx
print_status "Reiniciando Nginx..."
systemctl restart nginx
systemctl enable nginx

# 14. Instalar Certbot para SSL
print_status "Instalando Certbot para SSL..."
apt install -y certbot python3-certbot-nginx

# 15. Crear script de actualización automática
print_status "Creando script de actualización automática..."
cat > /usr/local/bin/update-docs.sh << 'EOF'
#!/bin/bash

SITE_PATH="/var/www/uneme-docs"
LOG_FILE="/var/log/update-docs.log"

echo "$(date): Iniciando actualización de documentación..." >> $LOG_FILE

cd $SITE_PATH

# Pull latest changes
git pull origin main >> $LOG_FILE 2>&1

# Rebuild documentation
mkdocs build >> $LOG_FILE 2>&1

echo "$(date): Actualización completada." >> $LOG_FILE
EOF

chmod +x /usr/local/bin/update-docs.sh

# 16. Configurar cron para actualizaciones automáticas
print_status "Configurando actualizaciones automáticas..."
cat > /etc/cron.d/update-docs << EOF
# Actualizar documentación cada 30 minutos
*/30 * * * * root /usr/local/bin/update-docs.sh
EOF

# 17. Crear script de monitoreo
print_status "Creando script de monitoreo..."
cat > /usr/local/bin/monitor-docs.sh << 'EOF'
#!/bin/bash

SITE_PATH="/var/www/uneme-docs"
DOMAIN="docs.uneme-cecosama.com"

# Check if site is accessible
if curl -f -s http://localhost > /dev/null; then
    echo "✅ Sitio accesible"
else
    echo "❌ Sitio no accesible - reiniciando Nginx"
    systemctl restart nginx
fi

# Check disk space
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo "⚠️  Advertencia: Uso de disco alto: ${DISK_USAGE}%"
fi

# Check if documentation is recent
LAST_BUILD=$(stat -c %Y $SITE_PATH/site/index.html 2>/dev/null || echo 0)
CURRENT_TIME=$(date +%s)
TIME_DIFF=$((CURRENT_TIME - LAST_BUILD))

if [ $TIME_DIFF -gt 86400 ]; then  # 24 hours
    echo "⚠️  Advertencia: Documentación no actualizada en 24h"
fi
EOF

chmod +x /usr/local/bin/monitor-docs.sh

# 18. Configurar permisos
print_status "Configurando permisos..."
chown -R www-data:www-data $SITE_PATH
chmod -R 755 $SITE_PATH

# 19. Mostrar información final
print_status "🎉 ¡Configuración completada!"
echo ""
echo "📋 Resumen de la instalación:"
echo "  • Sitio web: $SITE_PATH"
echo "  • Configuración Nginx: $NGINX_CONFIG"
echo "  • Logs de acceso: /var/log/nginx/$DOMAIN.access.log"
echo "  • Logs de error: /var/log/nginx/$DOMAIN.error.log"
echo ""
echo "🔧 Próximos pasos:"
echo "  1. Configurar DNS para apuntar $DOMAIN a esta IP"
echo "  2. Obtener certificado SSL:"
echo "     sudo certbot --nginx -d $DOMAIN"
echo "  3. Verificar sitio en: http://$(curl -s ifconfig.me)"
echo ""
echo "📚 Comandos útiles:"
echo "  • Actualizar docs: /usr/local/bin/update-docs.sh"
echo "  • Monitorear: /usr/local/bin/monitor-docs.sh"
echo "  • Logs Nginx: tail -f /var/log/nginx/$DOMAIN.access.log"
echo "  • Estado Nginx: systemctl status nginx"
echo ""

# 20. Verificar servicios
print_status "Verificando servicios..."
systemctl is-active --quiet nginx && echo "✅ Nginx activo" || echo "❌ Nginx inactivo"
systemctl is-enabled --quiet nginx && echo "✅ Nginx habilitado" || echo "❌ Nginx deshabilitado"

# 21. Mostrar IP pública
PUBLIC_IP=$(curl -s ifconfig.me)
print_status "IP pública del servidor: $PUBLIC_IP"

echo ""
print_status "Para completar la configuración:"
echo "1. Apunta tu dominio $DOMAIN a la IP $PUBLIC_IP"
echo "2. Ejecuta: sudo certbot --nginx -d $DOMAIN"
echo "3. Edita el script para usar tu repositorio real en REPO_URL"