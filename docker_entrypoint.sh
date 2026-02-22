#!/bin/sh
# No 'set -e' for a second so we can see errors clearly

echo "Starting Bifrost AI Gateway as root..."

# Ensure the directory exists
mkdir -p /app/data

# Run the binary directly as root
# This bypasses all permission issues with the mounted volume
exec /app/main \
    -app-dir /app/config \
    -host 0.0.0.0 \
    -port 8080