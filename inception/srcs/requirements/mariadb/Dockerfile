FROM debian:bookworm

# On installe le serveur et le client MariaDB
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Config custom : on autorise les connexions depuis les autres containers,
# pas seulement en local
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Notre script qui initialise la base au premier lancement
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/setup.sh"]
