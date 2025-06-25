# Droplet + Nginx - Configuración Manual Completa

## Paso 1: Crear Droplet en DigitalOcean

### 1.1 Configuración recomendada
```yaml
OS: Ubuntu 22.04 LTS
Size: Regular ($6/mes)
  - 1 GB RAM
  - 1 vCPU  
  - 25 GB SSD
  - 1000 GB Transfer
Region: Más cercano a usuarios
Authentication: SSH Key (recomendado)
Hostname: uneme-docs-server
```

### 1.2 Crear desde Dashboard
1. **Create** → **Droplet**
2. **Ubuntu 22.04 LTS**
3. **Regular $6/mes**
4. **Add SSH Key** (crear si no tienes)
5. **Create Droplet**

### 1.3 Conectar por SSH
```bash
# Obtener IP del droplet desde dashboard
ssh root@YOUR_DROPLET_IP
```

## Paso 2: Ejecutar Script de Configuración

### 2.1 Descargar y ejecutar script
```bash
# Conectado al droplet
wget https://raw.githubusercontent.com/TU-USUARIO/uneme-cecosama-docs/main/deploy/droplet-setup.sh
chmod +x droplet-setup.sh

# Editar variables antes de ejecutar
nano droplet-setup.sh
# Cambiar: REPO_URL y DOMAIN

# Ejecutar configuración
./droplet-setup.sh
```

### 2.2 Configuración manual (si prefieres paso a paso)
```bash
# 1. Actualizar sistema
apt update && apt upgrade -y

# 2. Instalar dependencias
apt install -y python3 python3-pip nginx git curl

# 3. Instalar MkDocs
pip3 install mkdocs mkdocs-material

# 4. Clonar repositorio
git clone https://github.com/TU-USUARIO/uneme-cecosama-docs.git /var/www/uneme-docs
cd /var/www/uneme-docs

# 5. Construir documentación
mkdocs build

# 6. Configurar Nginx (ver archivo de configuración abajo)
```

## Paso 3: Configuración de Nginx

### 3.1 Crear archivo de configuración
```bash
nano /etc/nginx/sites-available/uneme-docs
```

### 3.2 Configuración Nginx completa
```nginx
server {
    listen 80;
    server_name docs.uneme-cecosama.com www.docs.uneme-cecosama.com;
    
    # Redirect HTTP to HTTPS (after SSL setup)
    # return 301 https://$server_name$request_uri;
    
    # Document root
    root /var/www/uneme-docs/site;
    index index.html index.htm;
    
    # Main location
    location / {
        try_files $uri $uri/ =404;
        
        # Security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header X-Content-Type-Options "nosniff" always;
        
        # Cache static assets
        location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
            access_log off;
        }
    }
    
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
    
    # Security: hide sensitive files
    location ~ /\. {
        deny all;
    }
    
    location ~ /(mkdocs.yml|requirements.txt|\.git) {
        deny all;
    }
    
    # Logs
    access_log /var/log/nginx/uneme-docs.access.log;
    error_log /var/log/nginx/uneme-docs.error.log;
}

# HTTPS configuration (after SSL setup)
server {
    listen 443 ssl http2;
    server_name docs.uneme-cecosama.com www.docs.uneme-cecosama.com;
    
    # SSL certificates (will be configured by Certbot)
    ssl_certificate /etc/letsencrypt/live/docs.uneme-cecosama.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/docs.uneme-cecosama.com/privkey.pem;
    
    # Modern SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # HSTS
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    
    # Same content configuration as HTTP
    root /var/www/uneme-docs/site;
    index index.html index.htm;
    
    location / {
        try_files $uri $uri/ =404;
        
        # Security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header Referrer-Policy "no-referrer-when-downgrade" always;
        
        # Cache static assets
        location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
            access_log off;
        }
    }
    
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
    
    # Security: hide sensitive files
    location ~ /\. {
        deny all;
    }
    
    location ~ /(mkdocs.yml|requirements.txt|\.git) {
        deny all;
    }
    
    # Logs
    access_log /var/log/nginx/uneme-docs.access.log;
    error_log /var/log/nginx/uneme-docs.error.log;
}
```

### 3.3 Habilitar sitio
```bash
# Crear enlace simbólico
ln -s /etc/nginx/sites-available/uneme-docs /etc/nginx/sites-enabled/

# Deshabilitar sitio default
rm /etc/nginx/sites-enabled/default

# Verificar configuración
nginx -t

# Reiniciar Nginx
systemctl restart nginx
systemctl enable nginx
```

## Paso 4: Configurar SSL con Let's Encrypt

### 4.1 Instalar Certbot
```bash
apt install -y certbot python3-certbot-nginx
```

### 4.2 Configurar DNS primero
```bash
# En tu proveedor de DNS, crear registro A:
# docs.uneme-cecosama.com → IP_DE_TU_DROPLET
```

### 4.3 Obtener certificado SSL
```bash
# Obtener certificado
certbot --nginx -d docs.uneme-cecosama.com -d www.docs.uneme-cecosama.com

# Verificar auto-renovación
certbot renew --dry-run
```

## Paso 5: Configurar Actualizaciones Automáticas

### 5.1 Script de actualización
```bash
# Crear script
nano /usr/local/bin/update-docs.sh
```

```bash
#!/bin/bash
SITE_PATH="/var/www/uneme-docs"
LOG_FILE="/var/log/update-docs.log"

echo "$(date): Iniciando actualización..." >> $LOG_FILE
cd $SITE_PATH
git pull origin main >> $LOG_FILE 2>&1
mkdocs build >> $LOG_FILE 2>&1
echo "$(date): Actualización completada." >> $LOG_FILE
```

```bash
# Hacer ejecutable
chmod +x /usr/local/bin/update-docs.sh
```

### 5.2 Configurar cron
```bash
# Editar crontab
crontab -e

# Agregar línea para actualizar cada 30 minutos
*/30 * * * * /usr/local/bin/update-docs.sh
```

## Paso 6: Configurar Firewall

### 6.1 UFW básico
```bash
# Habilitar firewall
ufw --force enable

# Permitir conexiones necesarias
ufw allow ssh
ufw allow 'Nginx Full'
ufw allow 80
ufw allow 443

# Verificar status
ufw status
```

## Paso 7: Monitoreo y Mantenimiento

### 7.1 Script de monitoreo
```bash
nano /usr/local/bin/monitor-docs.sh
```

```bash
#!/bin/bash

# Check site accessibility
if ! curl -f -s http://localhost > /dev/null; then
    echo "$(date): Sitio no accesible - reiniciando Nginx" >> /var/log/monitor-docs.log
    systemctl restart nginx
fi

# Check disk space
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo "$(date): Advertencia - Disco lleno: ${DISK_USAGE}%" >> /var/log/monitor-docs.log
fi
```

```bash
chmod +x /usr/local/bin/monitor-docs.sh

# Ejecutar cada 5 minutos
echo "*/5 * * * * /usr/local/bin/monitor-docs.sh" | crontab -
```

### 7.2 Logs importantes
```bash
# Logs de acceso Nginx
tail -f /var/log/nginx/uneme-docs.access.log

# Logs de error Nginx
tail -f /var/log/nginx/uneme-docs.error.log

# Logs de actualización
tail -f /var/log/update-docs.log

# Logs del sistema
journalctl -u nginx -f
```

## Paso 8: Comandos de Gestión

### 8.1 Actualización manual
```bash
# Actualizar documentación
cd /var/www/uneme-docs
git pull origin main
mkdocs build

# Reiniciar servicios si es necesario
systemctl restart nginx
```

### 8.2 Verificación de estado
```bash
# Estado de servicios
systemctl status nginx
systemctl status cron

# Verificar sitio
curl -I http://docs.uneme-cecosama.com
curl -I https://docs.uneme-cecosama.com

# Verificar SSL
openssl s_client -connect docs.uneme-cecosama.com:443
```

### 8.3 Troubleshooting
```bash
# Si Nginx no inicia
nginx -t  # Verificar configuración
systemctl status nginx  # Ver errores

# Si SSL falla
certbot certificates  # Ver certificados
certbot renew --dry-run  # Probar renovación

# Si sitio no carga
ls -la /var/www/uneme-docs/site/  # Verificar archivos
tail /var/log/nginx/uneme-docs.error.log  # Ver errores
```

## Costos y Recursos

### Costo mensual estimado
- **Droplet $6/mes**: Regular (1GB RAM, 1 vCPU)
- **SSL**: Gratis (Let's Encrypt)  
- **Dominio**: Variable según proveedor
- **Total**: ~$6-8 USD/mes

### Recursos utilizados
- **RAM**: ~200-300MB
- **CPU**: <5% uso normal
- **Disco**: ~500MB para docs
- **Ancho de banda**: Mínimo para sitio estático

---
*Configuración completa para producción*  
*Control total del servidor*  
*Ideal para customización avanzada*