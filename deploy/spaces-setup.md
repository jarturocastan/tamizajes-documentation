#!/bin/bash

# UNEME-CECOSAMA Documentation - Upload to DigitalOcean Spaces
# Requires: s3cmd configured

set -e

# Configuration
SPACES_BUCKET="uneme-docs"
SPACES_REGION="nyc3" 
SPACES_ENDPOINT="https://nyc3.digitaloceanspaces.com"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if s3cmd is installed
if ! command -v s3cmd &> /dev/null; then
    print_error "s3cmd is not installed. Installing..."
    pip3 install s3cmd
fi

# Check if documentation is built
if [ ! -d "site" ]; then
    print_status "Building documentation..."
    mkdocs build --clean
fi

print_status "Starting upload to DigitalOcean Spaces..."

# Upload files with optimized settings
s3cmd sync site/ s3://${SPACES_BUCKET}/ \
    --acl-public \
    --delete-removed \
    --guess-mime-type \
    --no-mime-magic \
    --progress \
    --stats \
    --exclude="*.tmp" \
    --exclude=".DS_Store" \
    --exclude="*.log"

# Set specific caching headers for different file types
print_status "Setting cache headers..."

# HTML files - short cache
s3cmd modify s3://${SPACES_BUCKET}/ \
    --add-header="Cache-Control:public, max-age=300" \
    --add-header="Content-Type:text/html; charset=utf-8" \
    --recursive \
    --include="*.html"

# CSS files - long cache
s3cmd modify s3://${SPACES_BUCKET}/ \
    --add-header="Cache-Control:public, max-age=31536000" \
    --add-header="Content-Type:text/css; charset=utf-8" \
    --recursive \
    --include="*.css"

# JS files - long cache
s3cmd modify s3://${SPACES_BUCKET}/ \
    --add-header="Cache-Control:public, max-age=31536000" \
    --add-header="Content-Type:application/javascript; charset=utf-8" \
    --recursive \
    --include="*.js"

# Images - very long cache
s3cmd modify s3://${SPACES_BUCKET}/ \
    --add-header="Cache-Control:public, max-age=31536000" \
    --recursive \
    --include="*.png" --include="*.jpg" --include="*.jpeg" --include="*.gif" --include="*.svg"

# Fonts - very long cache
s3cmd modify s3://${SPACES_BUCKET}/ \
    --add-header="Cache-Control:public, max-age=31536000" \
    --recursive \
    --include="*.woff" --include="*.woff2" --include="*.ttf" --include="*.eot"

print_status "Upload completed successfully!"

# Display URLs
echo ""
echo "📋 Deployment Information:"
echo "  • Space URL: https://${SPACES_BUCKET}.${SPACES_REGION}.digitaloceanspaces.com/"
echo "  • CDN URL: https://your-cdn-endpoint.b-cdn.net/ (if configured)"
echo "  • Files uploaded: $(find site -type f | wc -l)"
echo "  • Total size: $(du -sh site | cut -f1)"

# Test accessibility
print_status "Testing site accessibility..."
SITE_URL="https://${SPACES_BUCKET}.${SPACES_REGION}.digitaloceanspaces.com/"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL")

if [ "$HTTP_STATUS" = "200" ]; then
    print_status "✅ Site is accessible at: $SITE_URL"
else
    print_error "❌ Site not accessible. HTTP Status: $HTTP_STATUS"
    exit 1
fi