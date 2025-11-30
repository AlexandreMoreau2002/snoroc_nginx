#!/bin/bash
set -e

echo "🔍 Testing Nginx configuration syntax..."

# Test each site configuration individually
for conf in nginx/sites/*.conf; do
    echo "  → Testing $(basename $conf)..."
    # Note: This is a basic syntax check
    # Full validation requires nginx binary with -t flag on the server
    if ! grep -q "server {" "$conf"; then
        echo "❌ Error: $conf doesn't contain a server block"
        exit 1
    fi
done

echo "✅ Basic syntax validation passed"
echo ""
echo "⚠️  Note: Full validation with 'nginx -t' will run on the server during deployment"
