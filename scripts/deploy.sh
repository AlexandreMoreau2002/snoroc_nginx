set -euo pipefail

echo "🚀 Deployment Nginx Snoroc starting..."

if [ ! -d "nginx/sites" ] || [ ! -d "nginx/snippets" ]; then
    echo "❌ Missing nginx configuration directories (nginx/sites or nginx/snippets)."
    exit 1
fi

PROD_CONF_SOURCE="nginx/sites/snoroc.conf"
DEV_CONF_SOURCE="nginx/sites/snoroc-dev.conf"
PROD_CONF_TARGET="/etc/nginx/sites-available/snoroc.conf"
DEV_CONF_TARGET="/etc/nginx/sites-available/snoroc-dev.conf"

# Safety rails: ensure we do not mix DEV/PROD paths
echo "🧪 Safety checks..."
if ! [ -f "$PROD_CONF_SOURCE" ] || ! [ -f "$DEV_CONF_SOURCE" ]; then
    echo "❌ Missing site configuration files in nginx/sites/"
    exit 1
fi

if grep -q "/srv/snoroc-dev" "$PROD_CONF_SOURCE"; then
    echo "❌ PROD configuration references DEV paths (/srv/snoroc-dev)."
    exit 1
fi

if grep -q "/srv/snoroc/" "$DEV_CONF_SOURCE"; then
    echo "❌ DEV configuration references PROD paths (/srv/snoroc/)."
    exit 1
fi

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

echo "🧹 Cleaning legacy site definitions..."
for legacy in /etc/nginx/sites-available/snoroc /etc/nginx/sites-available/snoroc-dev; do
    if [ -f "$legacy" ]; then
        echo "  → Removing legacy file $legacy (backed up in $BACKUP_DIR)"
        sudo rm -f "$legacy"
    fi
done
for legacy_link in /etc/nginx/sites-enabled/snoroc /etc/nginx/sites-enabled/snoroc-dev; do
    if [ -L "$legacy_link" ] || [ -f "$legacy_link" ]; then
        echo "  → Removing legacy symlink $legacy_link"
        sudo rm -f "$legacy_link"
    fi
done

# Copy site configurations
echo "📝 Copying site configurations..."
sudo mkdir -p /etc/nginx/sites-available
sudo cp "$PROD_CONF_SOURCE" "$PROD_CONF_TARGET"
sudo cp "$DEV_CONF_SOURCE" "$DEV_CONF_TARGET"

# Configure nginx.conf if needed
echo "🔧 Configuring nginx.conf for rate limiting..."
if ! grep -q "include /etc/nginx/snippets/rate-limit.conf" /etc/nginx/nginx.conf; then
    echo "  → Adding rate-limit.conf to nginx.conf..."
    
    # Backup nginx.conf
    sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
    
    # Add include before sites-enabled
    sudo sed -i '/include \/etc\/nginx\/sites-enabled/i \    # Rate limiting zones\n    include /etc/nginx/snippets/rate-limit.conf;\n' /etc/nginx/nginx.conf
    
    echo "  ✅ Rate limiting zones configured"
else
    echo "  ✅ Rate limiting already configured"
fi

# Create symlinks in sites-enabled
echo "🔗 Creating symlinks..."
sudo mkdir -p /etc/nginx/sites-enabled
sudo ln -sf "$PROD_CONF_TARGET" "/etc/nginx/sites-enabled/$(basename "$PROD_CONF_TARGET")"
echo "  → Linked $(basename "$PROD_CONF_TARGET")"
sudo ln -sf "$DEV_CONF_TARGET" "/etc/nginx/sites-enabled/$(basename "$DEV_CONF_TARGET")"
echo "  → Linked $(basename "$DEV_CONF_TARGET")"

# Remove broken symlinks
sudo find /etc/nginx/sites-enabled -xtype l -delete

# Test configuration
echo "🧪 Testing Nginx configuration..."
sudo nginx -t

# Reload Nginx (graceful, no downtime)
echo "🔄 Reloading Nginx..."
sudo systemctl reload nginx

echo "✅ Deployment completed successfully!"
echo "📊 Backup saved to: $BACKUP_DIR"
