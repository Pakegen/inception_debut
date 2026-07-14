# Remplace LOGIN par ton login 42 (ex: wil)
LOGIN = LOGIN
DATA_DIR = /home/$(LOGIN)/data
COMPOSE = srcs/docker-compose.yml

# 'all' prepare les dossiers de donnees puis lance tout
all: prepare up

# les volumes doivent exister sur l'hote AVANT de lancer docker compose
prepare:
	mkdir -p $(DATA_DIR)/wordpress
	mkdir -p $(DATA_DIR)/mariadb

up:
	docker compose -f $(COMPOSE) up --build -d

down:
	docker compose -f $(COMPOSE) down

stop:
	docker compose -f $(COMPOSE) stop

start:
	docker compose -f $(COMPOSE) start

# supprime les containers et images, mais garde les donnees
clean: down
	docker system prune -af

# tout supprime, y compris les donnees. A utiliser pour repartir de zero
fclean: clean
	sudo rm -rf $(DATA_DIR)
	docker volume prune -f

re: fclean all

.PHONY: all prepare up down stop start clean fclean re
