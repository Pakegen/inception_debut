FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-xml \
    php-mbstring \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# wp-cli permet d'installer et configurer wordpress en ligne de commande,
# sans passer par l'assistant d'installation dans le navigateur
RUN curl -o /usr/local/bin/wp -sS \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

WORKDIR /var/www/html

# Config du pool php-fpm : on le fait ecouter sur toutes les interfaces
# du container au lieu d'un socket local, pour que nginx puisse s'y connecter
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup.sh"]
