#!/bin/bash

# UNEME-CECOSAMA GitHub Pages Setup Script

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🚀 UNEME-CECOSAMA GitHub Pages Setup${NC}"
echo "====================================="
echo ""

# Get GitHub username
read -p "GitHub username: " GITHUB_USER
read -p "Repository name [uneme-cecosama-docs]: " REPO_NAME
REPO_NAME=${REPO_NAME:-uneme-cecosama-docs}

# Custom domain (optional)
read -p "Custom domain (optional, press Enter to skip): " CUSTOM_DOMAIN

echo ""
echo -e "${YELLOW}📋 Configuration:${NC}"
echo "  • GitHub User: $GITHUB_USER"
echo "  • Repository: $REPO_NAME"
echo "  • Custom Domain: ${CUSTOM_DOMAIN:-None}"
echo ""

read -p "Continue? [Y/n]: " CONFIRM
if [[ $CONFIRM =~ ^[Nn]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

echo ""
echo -e "${GREEN}📁 Initializing Git repository...${NC}"

# Initialize git if not already
if [ ! -d ".git" ]; then
    git init
fi

# Update GitHub repo in workflows
sed -i "s/TU-USUARIO/$GITHUB_USER/g" .github/workflows/deploy-docs.yml
sed -i "s/uneme-cecosama-docs/$REPO_NAME/g" .github/workflows/deploy-docs.yml

# Update mkdocs.yml with correct site_url
if [ -n "$CUSTOM_DOMAIN" ]; then
    sed -i "s/site_url: .*/site_url: 'https:\/\/$CUSTOM_DOMAIN'/" mkdocs.yml
    echo "$CUSTOM_DOMAIN" > docs/CNAME
    echo -e "${GREEN}✅ Custom domain configured: $CUSTOM_DOMAIN${NC}"
else
    sed -i "s/site_url: .*/site_url: 'https:\/\/$GITHUB_USER.github.io\/$REPO_NAME\/'/" mkdocs.yml
    rm -f docs/CNAME 2>/dev/null || true
fi

# Update repo_url in mkdocs.yml
sed -i "s/repo_url: .*/repo_url: 'https:\/\/github.com\/$GITHUB_USER\/$REPO_NAME'/" mkdocs.yml
sed -i "s/repo_name: .*/repo_name: '$GITHUB_USER\/$REPO_NAME'/" mkdocs.yml

echo -e "${GREEN}📝 Adding files to git...${NC}"
git add .
git commit -m "Initial commit: UNEME-CECOSAMA Documentation

- Documentación completa de formularios críticos (AUDIT, ASSIST, EBIS)
- Configuración automática para GitHub Pages
- Scripts de deployment incluidos
- 40 formularios identificados para documentación futura

🤖 Generated with Claude Code" || echo "No changes to commit"

# Set remote origin
REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"
git branch -M main

echo ""
echo -e "${GREEN}🔗 Repository configured: $REPO_URL${NC}"
echo ""
echo -e "${YELLOW}📤 Next steps:${NC}"
echo "1. Create repository on GitHub: https://github.com/new"
echo "   • Name: $REPO_NAME"
echo "   • Public (for free GitHub Pages)"
echo "   • DON'T initialize with README"
echo ""
echo "2. Push code:"
echo "   git push -u origin main"
echo ""
echo "3. Enable GitHub Pages:"
echo "   • Go to: https://github.com/$GITHUB_USER/$REPO_NAME/settings/pages"
echo "   • Source: Deploy from a branch"
echo "   • Branch: gh-pages"
echo "   • Save"
echo ""
echo "4. Wait ~2-3 minutes for first deploy"
echo ""

if [ -n "$CUSTOM_DOMAIN" ]; then
    echo -e "${YELLOW}🌐 DNS Configuration for $CUSTOM_DOMAIN:${NC}"
    echo "   Type: CNAME"
    echo "   Name: docs"
    echo "   Value: $GITHUB_USER.github.io"
    echo ""
fi

echo -e "${GREEN}📖 Your documentation will be available at:${NC}"
if [ -n "$CUSTOM_DOMAIN" ]; then
    echo "   https://$CUSTOM_DOMAIN"
else
    echo "   https://$GITHUB_USER.github.io/$REPO_NAME/"
fi

echo ""
echo -e "${GREEN}✨ Setup complete! Ready to push to GitHub.${NC}"