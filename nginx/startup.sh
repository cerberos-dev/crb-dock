#!/bin/bash

if [ ! -f /etc/nginx/ssl/crb-dock.crt ]; then
    openssl req -new \
        -newkey rsa:4096 \
        -x509 \
        -sha256 \
        -days 365 \
        -nodes \
        -subj "/CN=CRB-Dock/O=Cerberos/C=NL" \
        -out '/etc/nginx/ssl/crb-dock.crt' \
        -keyout '/etc/nginx/ssl/crb-dock.key'

    chmod 644 /etc/nginx/ssl/crb-dock.key
fi

# Start crond in background
crond -l 2 -b

# Start nginx in foreground
nginx
