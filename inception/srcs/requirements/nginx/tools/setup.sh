#!/bin/bash
set -e

if [ ! -f "/etc/nginx/ssl/inception.crt" ]; then
    echo ">> Generation du certificat TLS auto-signe"
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/CN=${DOMAIN_NAME}"
fi

envsubst '${DOMAIN_NAME}' < /etc/nginx/sites-available/wordpress.conf > /tmp/wordpress.conf
mv /tmp/wordpress.conf /etc/nginx/sites-available/wordpress.conf

echo ">> Demarrage de NGINX"
exec nginx -g "daemon off;"
