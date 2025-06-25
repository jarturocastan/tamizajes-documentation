#!/bin/bash

# UNEME-CECOSAMA Documentation - Universal Deployment Script
# Deploys to multiple platforms simultaneously

set -e

# Configuration
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$REPO_DIR/site"
LOG_DIR="$REPO_DIR/logs"
CONFIG_FILE="$REPO_DIR/deploy/config.env"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Create logs directory
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_DIR/deploy.log"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a "$LOG_DIR/deploy.log"
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1" | tee -a "$LOG_DIR/deploy.log"
}

log_info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO:${NC} $1" | tee -a "$LOG_DIR/deploy.log"
}

# Load configuration
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        log "Loading configuration from $CONFIG_FILE"
        source "$CONFIG_FILE"
    else
        log_warning "Configuration file not found. Using defaults."
        create_default_config
    fi
}

# Create default configuration
create_default_config() {
    cat > "$CONFIG_FILE" << 'EOF'
# UNEME-CECOSAMA Documentation Deployment Configuration

# App Platform
APP_PLATFORM_ENABLED=true
APP_PLATFORM_URL="https://uneme-cecosama-docs-xxxxx.ondigitalocean.app"

# Droplet Configuration
DROPLET_ENABLED=false
DROPLET_HOST=""
DROPLET_USER="root"
DROPLET_PATH="/var/www/uneme-docs"

# GitHub Pages
GITHUB_PAGES_ENABLED=true
GITHUB_REPO="TU-USUARIO/uneme-cecosama-docs"

# DigitalOcean Spaces
SPACES_ENABLED=false
SPACES_BUCKET="uneme-docs"
SPACES_REGION="nyc3"
SPACES_ENDPOINT="nyc3.digitaloceanspaces.com"

# CDN Configuration
CDN_ENABLED=false
CDN_ENDPOINT=""

# Domain Configuration
CUSTOM_DOMAIN="docs.uneme-cecosama.com"

# Notification Settings
SLACK_WEBHOOK=""
DISCORD_WEBHOOK=""
EMAIL_NOTIFICATION=""
EOF
    log "Created default configuration at $CONFIG_FILE"
    log "Please edit $CONFIG_FILE with your specific settings"
}

# Check dependencies
check_dependencies() {
    log "Checking dependencies..."
    
    local missing_deps=()
    
    # Check Python and MkDocs
    if ! command -v python3 &> /dev/null; then
        missing_deps+=("python3")
    fi
    
    if ! command -v mkdocs &> /dev/null; then
        missing_deps+=("mkdocs")
    fi
    
    # Check git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    # Check optional dependencies
    if [ "$SPACES_ENABLED" = "true" ] && ! command -v s3cmd &> /dev/null; then
        log_warning "s3cmd not found. Installing for Spaces deployment..."
        pip3 install s3cmd
    fi
    
    if [ "$DROPLET_ENABLED" = "true" ] && ! command -v ssh &> /dev/null; then
        missing_deps+=("ssh")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        log "Please install missing dependencies and try again"
        exit 1
    fi
    
    log "✅ All dependencies satisfied"
}

# Build documentation
build_docs() {
    log "Building documentation..."
    
    cd "$REPO_DIR"
    
    # Clean previous build
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
    fi
    
    # Build with MkDocs
    if mkdocs build --clean --verbose > "$LOG_DIR/build.log" 2>&1; then
        log "✅ Documentation built successfully"
        log_info "Build output saved to $LOG_DIR/build.log"
        
        # Show build stats
        local file_count=$(find "$BUILD_DIR" -type f | wc -l)
        local total_size=$(du -sh "$BUILD_DIR" | cut -f1)
        log_info "Generated $file_count files, total size: $total_size"
    else
        log_error "Documentation build failed"
        log_error "Check $LOG_DIR/build.log for details"
        cat "$LOG_DIR/build.log"
        exit 1
    fi
}

# Deploy to GitHub Pages
deploy_github_pages() {
    if [ "$GITHUB_PAGES_ENABLED" != "true" ]; then
        log_info "GitHub Pages deployment disabled"
        return 0
    fi
    
    log "Deploying to GitHub Pages..."
    
    if mkdocs gh-deploy --force > "$LOG_DIR/github-pages.log" 2>&1; then
        log "✅ GitHub Pages deployment successful"
        local pages_url="https://$(echo $GITHUB_REPO | tr '/' '.').github.io/"
        log_info "URL: $pages_url"
    else
        log_error "GitHub Pages deployment failed"
        cat "$LOG_DIR/github-pages.log"
        return 1
    fi
}

# Deploy to DigitalOcean Spaces
deploy_spaces() {
    if [ "$SPACES_ENABLED" != "true" ]; then
        log_info "Spaces deployment disabled"
        return 0
    fi
    
    log "Deploying to DigitalOcean Spaces..."
    
    # Check s3cmd configuration
    if [ ! -f ~/.s3cfg ]; then
        log_error "s3cmd not configured. Run 's3cmd --configure' first"
        return 1
    fi
    
    # Upload to Spaces
    if s3cmd sync "$BUILD_DIR/" "s3://$SPACES_BUCKET/" \
        --acl-public \
        --delete-removed \
        --guess-mime-type \
        --progress > "$LOG_DIR/spaces.log" 2>&1; then
        
        log "✅ Spaces deployment successful"
        local spaces_url="https://$SPACES_BUCKET.$SPACES_REGION.digitaloceanspaces.com/"
        log_info "URL: $spaces_url"
        
        # Set cache headers
        set_spaces_cache_headers
    else
        log_error "Spaces deployment failed"
        cat "$LOG_DIR/spaces.log"
        return 1
    fi
}

# Set optimized cache headers for Spaces
set_spaces_cache_headers() {
    log_info "Setting optimized cache headers..."
    
    # HTML files - short cache (5 minutes)
    s3cmd modify "s3://$SPACES_BUCKET/" \
        --add-header="Cache-Control:public, max-age=300" \
        --recursive --include="*.html" >> "$LOG_DIR/spaces.log" 2>&1
    
    # CSS/JS files - long cache (1 year)
    s3cmd modify "s3://$SPACES_BUCKET/" \
        --add-header="Cache-Control:public, max-age=31536000" \
        --recursive --include="*.css" --include="*.js" >> "$LOG_DIR/spaces.log" 2>&1
    
    # Images - very long cache
    s3cmd modify "s3://$SPACES_BUCKET/" \
        --add-header="Cache-Control:public, max-age=31536000" \
        --recursive --include="*.png" --include="*.jpg" --include="*.svg" >> "$LOG_DIR/spaces.log" 2>&1
}

# Deploy to Droplet
deploy_droplet() {
    if [ "$DROPLET_ENABLED" != "true" ]; then
        log_info "Droplet deployment disabled"
        return 0
    fi
    
    log "Deploying to Droplet..."
    
    if [ -z "$DROPLET_HOST" ]; then
        log_error "DROPLET_HOST not configured"
        return 1
    fi
    
    # Upload files via rsync
    if rsync -avz --delete "$BUILD_DIR/" "$DROPLET_USER@$DROPLET_HOST:$DROPLET_PATH/site/" > "$LOG_DIR/droplet.log" 2>&1; then
        log "✅ Droplet deployment successful"
        
        # Restart nginx if needed
        ssh "$DROPLET_USER@$DROPLET_HOST" "systemctl reload nginx" >> "$LOG_DIR/droplet.log" 2>&1
        
        if [ -n "$CUSTOM_DOMAIN" ]; then
            log_info "URL: https://$CUSTOM_DOMAIN/"
        else
            log_info "URL: http://$DROPLET_HOST/"
        fi
    else
        log_error "Droplet deployment failed"
        cat "$LOG_DIR/droplet.log"
        return 1
    fi
}

# Test deployments
test_deployments() {
    log "Testing deployments..."
    
    local test_urls=()
    
    # Collect URLs to test
    if [ "$GITHUB_PAGES_ENABLED" = "true" ]; then
        test_urls+=("https://$(echo $GITHUB_REPO | tr '/' '.').github.io/")
    fi
    
    if [ "$SPACES_ENABLED" = "true" ]; then
        test_urls+=("https://$SPACES_BUCKET.$SPACES_REGION.digitaloceanspaces.com/")
    fi
    
    if [ "$DROPLET_ENABLED" = "true" ] && [ -n "$CUSTOM_DOMAIN" ]; then
        test_urls+=("https://$CUSTOM_DOMAIN/")
    fi
    
    if [ "$APP_PLATFORM_ENABLED" = "true" ] && [ -n "$APP_PLATFORM_URL" ]; then
        test_urls+=("$APP_PLATFORM_URL")
    fi
    
    # Test each URL
    local failed_tests=0
    for url in "${test_urls[@]}"; do
        log_info "Testing: $url"
        
        local http_status=$(curl -s -o /dev/null -w "%{http_code}" "$url" --max-time 30)
        
        if [ "$http_status" = "200" ]; then
            log "✅ $url - OK ($http_status)"
        else
            log_error "❌ $url - Failed ($http_status)"
            failed_tests=$((failed_tests + 1))
        fi
    done
    
    if [ $failed_tests -eq 0 ]; then
        log "✅ All deployment tests passed"
    else
        log_warning "$failed_tests deployment(s) failed testing"
    fi
}

# Send notifications
send_notifications() {
    local status="$1"
    local message="$2"
    
    if [ -n "$SLACK_WEBHOOK" ]; then
        send_slack_notification "$status" "$message"
    fi
    
    if [ -n "$DISCORD_WEBHOOK" ]; then
        send_discord_notification "$status" "$message"
    fi
    
    if [ -n "$EMAIL_NOTIFICATION" ]; then
        send_email_notification "$status" "$message"
    fi
}

# Send Slack notification
send_slack_notification() {
    local status="$1"
    local message="$2"
    local color
    
    if [ "$status" = "success" ]; then
        color="good"
    else
        color="danger"
    fi
    
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"attachments\":[{\"color\":\"$color\",\"text\":\"$message\"}]}" \
        "$SLACK_WEBHOOK" > /dev/null 2>&1
}

# Send Discord notification
send_discord_notification() {
    local status="$1"
    local message="$2"
    
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"content\":\"$message\"}" \
        "$DISCORD_WEBHOOK" > /dev/null 2>&1
}

# Send email notification
send_email_notification() {
    local status="$1"
    local message="$2"
    
    if command -v mail &> /dev/null; then
        echo "$message" | mail -s "UNEME Documentation Deployment - $status" "$EMAIL_NOTIFICATION"
    fi
}

# Generate deployment report
generate_report() {
    local report_file="$LOG_DIR/deployment-report-$(date +%Y%m%d-%H%M%S).md"
    
    cat > "$report_file" << EOF
# UNEME-CECOSAMA Documentation Deployment Report

**Date:** $(date)  
**Status:** $1  
**Duration:** $2  

## Deployment Summary

| Platform | Status | URL |
|----------|--------|-----|
EOF

    # Add platform status to report
    if [ "$GITHUB_PAGES_ENABLED" = "true" ]; then
        echo "| GitHub Pages | ✅ Deployed | https://$(echo $GITHUB_REPO | tr '/' '.').github.io/ |" >> "$report_file"
    fi
    
    if [ "$SPACES_ENABLED" = "true" ]; then
        echo "| DigitalOcean Spaces | ✅ Deployed | https://$SPACES_BUCKET.$SPACES_REGION.digitaloceanspaces.com/ |" >> "$report_file"
    fi
    
    if [ "$DROPLET_ENABLED" = "true" ]; then
        echo "| Droplet | ✅ Deployed | https://$CUSTOM_DOMAIN/ |" >> "$report_file"
    fi
    
    if [ "$APP_PLATFORM_ENABLED" = "true" ]; then
        echo "| App Platform | ✅ Auto-deploy | $APP_PLATFORM_URL |" >> "$report_file"
    fi
    
    cat >> "$report_file" << EOF

## Build Statistics

- **Files generated:** $(find "$BUILD_DIR" -type f 2>/dev/null | wc -l)
- **Total size:** $(du -sh "$BUILD_DIR" 2>/dev/null | cut -f1)
- **Build time:** $(grep "Built in" "$LOG_DIR/build.log" 2>/dev/null | tail -1 || echo "N/A")

## Logs

- Build log: \`$LOG_DIR/build.log\`
- GitHub Pages log: \`$LOG_DIR/github-pages.log\`
- Spaces log: \`$LOG_DIR/spaces.log\`
- Droplet log: \`$LOG_DIR/droplet.log\`

---
*Generated by UNEME-CECOSAMA deployment script*
EOF

    log "📊 Deployment report generated: $report_file"
}

# Main deployment function
main() {
    local start_time=$(date +%s)
    
    echo -e "${PURPLE}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║        UNEME-CECOSAMA Documentation Deployment        ║"
    echo "║                 Universal Deploy Script               ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log "Starting deployment process..."
    
    # Load configuration
    load_config
    
    # Check dependencies
    check_dependencies
    
    # Build documentation
    build_docs
    
    # Deploy to configured platforms
    local deployment_errors=0
    
    if ! deploy_github_pages; then
        deployment_errors=$((deployment_errors + 1))
    fi
    
    if ! deploy_spaces; then
        deployment_errors=$((deployment_errors + 1))
    fi
    
    if ! deploy_droplet; then
        deployment_errors=$((deployment_errors + 1))
    fi
    
    # Test deployments
    test_deployments
    
    # Calculate duration
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local duration_formatted=$(printf '%02d:%02d' $((duration/60)) $((duration%60)))
    
    # Generate report
    if [ $deployment_errors -eq 0 ]; then
        generate_report "SUCCESS" "$duration_formatted"
        send_notifications "success" "✅ UNEME Documentation deployed successfully to all platforms (${duration_formatted})"
        log "🎉 Deployment completed successfully in $duration_formatted"
        
        echo -e "${GREEN}"
        echo "╔════════════════════════════════════════╗"
        echo "║           Deployment Complete!         ║"
        echo "║              ✅ SUCCESS ✅              ║"
        echo "╚════════════════════════════════════════╝"
        echo -e "${NC}"
        
    else
        generate_report "PARTIAL" "$duration_formatted"
        send_notifications "warning" "⚠️ UNEME Documentation deployment completed with $deployment_errors error(s)"
        log_warning "Deployment completed with $deployment_errors error(s) in $duration_formatted"
        
        echo -e "${YELLOW}"
        echo "╔════════════════════════════════════════╗"
        echo "║         Deployment Completed          ║"
        echo "║           ⚠️  WITH ERRORS ⚠️           ║"
        echo "╚════════════════════════════════════════╝"
        echo -e "${NC}"
    fi
    
    # Show access URLs
    echo ""
    log_info "📚 Documentation URLs:"
    
    if [ "$GITHUB_PAGES_ENABLED" = "true" ]; then
        log_info "  • GitHub Pages: https://$(echo $GITHUB_REPO | tr '/' '.').github.io/"
    fi
    
    if [ "$SPACES_ENABLED" = "true" ]; then
        log_info "  • DigitalOcean Spaces: https://$SPACES_BUCKET.$SPACES_REGION.digitaloceanspaces.com/"
    fi
    
    if [ "$DROPLET_ENABLED" = "true" ] && [ -n "$CUSTOM_DOMAIN" ]; then
        log_info "  • Custom Domain: https://$CUSTOM_DOMAIN/"
    fi
    
    if [ "$APP_PLATFORM_ENABLED" = "true" ] && [ -n "$APP_PLATFORM_URL" ]; then
        log_info "  • App Platform: $APP_PLATFORM_URL"
    fi
    
    log "Deployment process completed."
}

# Show help
show_help() {
    cat << EOF
UNEME-CECOSAMA Documentation Universal Deployment Script

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help                Show this help message
    -c, --config FILE         Use specific configuration file
    -b, --build-only          Only build documentation, don't deploy
    -t, --test-only           Only test existing deployments
    --skip-github            Skip GitHub Pages deployment
    --skip-spaces            Skip Spaces deployment
    --skip-droplet           Skip Droplet deployment
    --force                  Force deployment even if tests fail

EXAMPLES:
    $0                       Deploy to all configured platforms
    $0 --build-only          Only build the documentation
    $0 --skip-github         Deploy to all platforms except GitHub Pages
    $0 -c custom.env         Use custom configuration file

CONFIGURATION:
    Edit deploy/config.env to configure deployment targets and settings.

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -c|--config)
            CONFIG_FILE="$2"
            shift 2
            ;;
        -b|--build-only)
            BUILD_ONLY=true
            shift
            ;;
        -t|--test-only)
            TEST_ONLY=true
            shift
            ;;
        --skip-github)
            GITHUB_PAGES_ENABLED=false
            shift
            ;;
        --skip-spaces)
            SPACES_ENABLED=false
            shift
            ;;
        --skip-droplet)
            DROPLET_ENABLED=false
            shift
            ;;
        --force)
            FORCE_DEPLOY=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Execute based on options
if [ "$TEST_ONLY" = "true" ]; then
    load_config
    test_deployments
elif [ "$BUILD_ONLY" = "true" ]; then
    load_config
    check_dependencies
    build_docs
    log "✅ Build completed. Files available in: $BUILD_DIR"
else
    main "$@"
fi