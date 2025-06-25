#!/bin/bash

# UNEME-CECOSAMA Documentation - Quick Deploy Script
# Simple deployment script for common use cases

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${GREEN}🚀 UNEME-CECOSAMA Quick Deploy${NC}"
echo "=================================="
echo ""

# Function to prompt user
prompt() {
    local question="$1"
    local default="$2"
    local response
    
    if [ -n "$default" ]; then
        read -p "$question [$default]: " response
        echo "${response:-$default}"
    else
        read -p "$question: " response
        echo "$response"
    fi
}

# Function to yes/no prompt
prompt_yn() {
    local question="$1"
    local default="$2"
    local response
    
    while true; do
        if [ "$default" = "y" ]; then
            read -p "$question [Y/n]: " response
            response="${response:-y}"
        else
            read -p "$question [y/N]: " response
            response="${response:-n}"
        fi
        
        case "$response" in
            [Yy]* ) echo "y"; break;;
            [Nn]* ) echo "n"; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Check if this is first run
if [ ! -f "$SCRIPT_DIR/config.env" ]; then
    echo -e "${YELLOW}First time setup detected!${NC}"
    echo "Let's configure your deployment settings..."
    echo ""
    
    # Get basic configuration
    github_user=$(prompt "GitHub username")
    repo_name=$(prompt "Repository name" "uneme-cecosama-docs")
    domain=$(prompt "Custom domain (optional)" "docs.uneme-cecosama.com")
    
    # Ask about deployment targets
    echo ""
    echo "Which platforms would you like to deploy to?"
    
    github_pages=$(prompt_yn "Deploy to GitHub Pages (free)?" "y")
    app_platform=$(prompt_yn "Deploy to DigitalOcean App Platform?" "y")
    spaces=$(prompt_yn "Deploy to DigitalOcean Spaces?" "n")
    droplet=$(prompt_yn "Deploy to custom Droplet?" "n")
    
    # Create configuration
    cat > "$SCRIPT_DIR/config.env" << EOF
# Quick Deploy Configuration
GITHUB_PAGES_ENABLED=${github_pages}
GITHUB_REPO="${github_user}/${repo_name}"

APP_PLATFORM_ENABLED=${app_platform}
APP_PLATFORM_URL=""

SPACES_ENABLED=${spaces}
SPACES_BUCKET="uneme-docs"
SPACES_REGION="nyc3"

DROPLET_ENABLED=${droplet}
DROPLET_HOST=""
DROPLET_USER="root"

CUSTOM_DOMAIN="${domain}"
EOF
    
    echo ""
    echo -e "${GREEN}✅ Configuration saved!${NC}"
    echo "You can edit $SCRIPT_DIR/config.env later to modify settings"
    echo ""
fi

# Load configuration
source "$SCRIPT_DIR/config.env"

# Show deployment plan
echo "📋 Deployment Plan:"
echo "==================="

if [ "$GITHUB_PAGES_ENABLED" = "y" ]; then
    echo "✅ GitHub Pages: https://${GITHUB_REPO/\//.}.github.io/"
fi

if [ "$APP_PLATFORM_ENABLED" = "y" ]; then
    echo "✅ App Platform: Auto-deploy from GitHub"
fi

if [ "$SPACES_ENABLED" = "y" ]; then
    echo "✅ DigitalOcean Spaces: https://$SPACES_BUCKET.$SPACES_REGION.digitaloceanspaces.com/"
fi

if [ "$DROPLET_ENABLED" = "y" ] && [ -n "$DROPLET_HOST" ]; then
    echo "✅ Droplet: https://$CUSTOM_DOMAIN/"
fi

echo ""

# Ask for confirmation
if [ "$(prompt_yn "Proceed with deployment?")" != "y" ]; then
    echo "Deployment cancelled."
    exit 0
fi

echo ""
echo "🔨 Building documentation..."

# Change to project directory
cd "$PROJECT_DIR"

# Check if MkDocs is installed
if ! command -v mkdocs &> /dev/null; then
    echo -e "${RED}❌ MkDocs not found${NC}"
    echo "Installing MkDocs..."
    pip3 install -r requirements.txt
fi

# Build documentation
if ! mkdocs build --clean; then
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Documentation built successfully${NC}"

# Deploy to GitHub Pages
if [ "$GITHUB_PAGES_ENABLED" = "y" ]; then
    echo ""
    echo "🚀 Deploying to GitHub Pages..."
    
    if mkdocs gh-deploy --force; then
        echo -e "${GREEN}✅ GitHub Pages deployment successful${NC}"
        echo "📖 URL: https://${GITHUB_REPO/\//.}.github.io/"
    else
        echo -e "${RED}❌ GitHub Pages deployment failed${NC}"
    fi
fi

# Deploy to Spaces
if [ "$SPACES_ENABLED" = "y" ]; then
    echo ""
    echo "🚀 Deploying to DigitalOcean Spaces..."
    
    # Check if s3cmd is configured
    if ! command -v s3cmd &> /dev/null; then
        echo "Installing s3cmd..."
        pip3 install s3cmd
    fi
    
    if [ ! -f ~/.s3cfg ]; then
        echo -e "${YELLOW}⚠️  s3cmd not configured${NC}"
        echo "Please run 's3cmd --configure' first to set up your DigitalOcean Spaces credentials"
        echo "You can skip this for now and configure it later"
        if [ "$(prompt_yn "Configure s3cmd now?")" = "y" ]; then
            s3cmd --configure
        fi
    fi
    
    if [ -f ~/.s3cfg ]; then
        if s3cmd sync site/ "s3://$SPACES_BUCKET/" --acl-public --delete-removed; then
            echo -e "${GREEN}✅ Spaces deployment successful${NC}"
            echo "📖 URL: https://$SPACES_BUCKET.$SPACES_REGION.digitaloceanspaces.com/"
        else
            echo -e "${RED}❌ Spaces deployment failed${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Skipping Spaces deployment (not configured)${NC}"
    fi
fi

# Deploy to Droplet
if [ "$DROPLET_ENABLED" = "y" ]; then
    echo ""
    echo "🚀 Deploying to Droplet..."
    
    if [ -z "$DROPLET_HOST" ]; then
        droplet_host=$(prompt "Droplet IP or hostname")
        # Update config
        sed -i "s/DROPLET_HOST=\"\"/DROPLET_HOST=\"$droplet_host\"/" "$SCRIPT_DIR/config.env"
        DROPLET_HOST="$droplet_host"
    fi
    
    if rsync -avz --delete site/ "$DROPLET_USER@$DROPLET_HOST:/var/www/uneme-docs/site/"; then
        # Restart nginx
        ssh "$DROPLET_USER@$DROPLET_HOST" "systemctl reload nginx" 2>/dev/null || true
        echo -e "${GREEN}✅ Droplet deployment successful${NC}"
        echo "📖 URL: https://$CUSTOM_DOMAIN/"
    else
        echo -e "${RED}❌ Droplet deployment failed${NC}"
    fi
fi

echo ""
echo "🎉 Deployment completed!"
echo ""

# Show summary
echo "📊 Deployment Summary:"
echo "======================"
echo "• Files generated: $(find site -type f | wc -l)"
echo "• Total size: $(du -sh site | cut -f1)"
echo "• Build time: $(date)"

echo ""
echo "🔗 Access your documentation:"

if [ "$GITHUB_PAGES_ENABLED" = "y" ]; then
    echo "  • GitHub Pages: https://${GITHUB_REPO/\//.}.github.io/"
fi

if [ "$SPACES_ENABLED" = "y" ]; then
    echo "  • DigitalOcean Spaces: https://$SPACES_BUCKET.$SPACES_REGION.digitaloceanspaces.com/"
fi

if [ "$DROPLET_ENABLED" = "y" ] && [ -n "$DROPLET_HOST" ]; then
    echo "  • Custom Domain: https://$CUSTOM_DOMAIN/"
fi

if [ "$APP_PLATFORM_ENABLED" = "y" ]; then
    echo ""
    echo -e "${YELLOW}💡 For App Platform:${NC}"
    echo "   1. Push your code to GitHub"
    echo "   2. Connect your repository in DigitalOcean App Platform"
    echo "   3. Auto-deploy will handle the rest!"
fi

echo ""
echo "📝 Next steps:"
echo "  • To update: edit files in docs/ and run this script again"
echo "  • To configure: edit $SCRIPT_DIR/config.env"
echo "  • For advanced features: use $SCRIPT_DIR/deploy-all.sh"
echo ""
echo "✨ Happy documenting!"