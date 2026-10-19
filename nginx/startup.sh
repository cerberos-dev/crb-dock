#!/bin/bash
set -euo pipefail

SSL_DIR="/etc/nginx/ssl"
CERT_FILE="${SSL_DIR}/crb-dock.crt"
KEY_FILE="${SSL_DIR}/crb-dock.key"

if [ ! -f "${CERT_FILE}" ]; then
    mkdir -p "${SSL_DIR}"

    openssl req -new \
        -newkey rsa:4096 \
        -x509 \
        -sha256 \
        -days 365 \
        -nodes \
        -subj "/CN=CRB-Dock/O=Cerberos/C=NL" \
        -addext "subjectAltName=DNS:crb-dock.localhost,DNS:crb-dock.local,DNS:crb-dock.crb,DNS:localhost,IP:127.0.0.1" \
        -out "${CERT_FILE}" \
        -keyout "${KEY_FILE}"

    chmod 600 "${KEY_FILE}"
fi

# Start crond in background
crond -l 2 -b

# Start nginx in foreground
nginx
