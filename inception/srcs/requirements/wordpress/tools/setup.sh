#!/bin/bash
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)

WP_ADMIN_PASSWORD=$(sed -n '1p' /run/secrets/credentials)
WP_USER_PASSWORD=$(sed -n '2p' /run/secrets/credentials)

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo ">> Premier lancement : telechargement et configuration de WordPress"

    wp core download --allow-root

    until mysqladmin ping -h mariadb --silent; do
        echo "En attente de MariaDB..."
        sleep 2
    done

    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost=mariadb \
        --allow-root

    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=editor \
        --allow-root

    chown -R www-data:www-data /var/www/html
fi

echo ">> Demarrage de php-fpm"
exec php-fpm8.2 -F
