# Remplace LOGIN par ton login 42 (ex: wil)
LOGIN = LOGIN
DATA_DIR = /home/$(LOGIN)/data
COMPOSE = srcs/docker-compose.yml

all: prepare up

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

clean: down
	docker system prune -af

fclean: clean
	sudo rm -rf $(DATA_DIR)
	docker volume prune -f

re: fclean all

.PHONY: all prepare up down stop start clean fclean re
