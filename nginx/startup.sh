#!/bin/bash

if [ ! -f /etc/nginx/ssl/crb-dock.crt ]; then
    openssl genrsa -out "/etc/nginx/ssl/crb-dock.key" 2048
    openssl req -new -key "/etc/nginx/ssl/crb-dock.key" -out "/etc/nginx/ssl/crb-dock.csr" -subj "/CN=CRB-Dock/O=CRB-Dock/C=NL" -addext "extendedKeyUsage=serverAuth"
    openssl x509 -req -days 365 -in "/etc/nginx/ssl/crb-dock.csr" -signkey "/etc/nginx/ssl/crb-dock.key" -out "/etc/nginx/ssl/crb-dock.crt"

    chmod 644 /etc/nginx/ssl/crb-dock.key
fi

# Start crond in background
crond -l 2 -b

# Start nginx in foreground
nginx
