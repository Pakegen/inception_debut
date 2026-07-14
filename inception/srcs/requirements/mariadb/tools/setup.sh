#!/bin/bash
set -e

# Les mots de passe ne sont jamais dans le Dockerfile ni dans l'image :
# on les lit depuis les secrets Docker, montes automatiquement dans /run/secrets/
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# On initialise la base seulement la toute premiere fois.
# Les fois suivantes, le dossier /var/lib/mysql (notre volume) contiendra deja les donnees.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo ">> Premier lancement : initialisation de MariaDB"

    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # On demarre temporairement le serveur en arriere-plan pour pouvoir
    # executer nos requetes SQL de configuration
    mysqld_safe --datadir=/var/lib/mysql &

    # On attend que le serveur soit pret a repondre
    until mysqladmin ping --silent; do
        sleep 1
    done

    mysql -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL

    # On arrete ce serveur temporaire : le vrai demarrage se fait juste apres
    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
fi

echo ">> Demarrage de MariaDB"
exec mysqld_safe --datadir=/var/lib/mysql
