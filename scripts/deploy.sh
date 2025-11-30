#!/bin/bash
set -e

echo "🚀 Deployment Nginx Snoroc starting..."

# Backup current configuration
echo "📦 Creating backup of current configuration..."
BACKUP_DIR="/etc/nginx/backup/$(date +%Y%m%d_%H%M%S)"
sudo mkdir -p "$BACKUP_DIR"
sudo cp -r /etc/nginx/sites-available/* "$BACKUP_DIR/" 2>/dev/null || true
sudo cp -r /etc/nginx/snippets/* "$BACKUP_DIR/" 2>/dev/null || true

# Copy snippets
echo "📝 Copying snippets..."
sudo mkdir -p /etc/nginx/snippets
sudo cp -r nginx/snippets/* /etc/nginx/snippets/

# Copy site configurations
echo "📝 Copying site configurations..."
sudo mkdir -p /etc/nginx/sites-available
sudo cp -r nginx/sites/* /etc/nginx/sites-available/

# Create symlinks in sites-enabled
echo "🔗 Creating symlinks..."
sudo mkdir -p /etc/nginx/sites-enabled
for conf in nginx/sites/*.conf; do
    CONF_NAME=$(basename "$conf")
    sudo ln -sf "/etc/nginx/sites-available/$CONF_NAME" "/etc/nginx/sites-enabled/$CONF_NAME"
    echo "  → Linked $CONF_NAME"
done

# Test configuration
echo "🧪 Testing Nginx configuration..."
sudo nginx -t

# Reload Nginx (graceful, no downtime)
echo "🔄 Reloading Nginx..."
sudo systemctl reload nginx

echo "✅ Deployment completed successfully!"
echo "📊 Backup saved to: $BACKUP_DIR"
