# -*- mode: makefile -*-

COMPOSE = docker-compose
DOCKER_HTTP = httpd
DOCKER_APP = php
ROOT = /var/www/ghibliql
COMPOSER = composer
PHPUNIT = ./vendor/bin/phpunit
CSFIXER = ./vendor/bin/php-cs-fixer
STAN = ./vendor/bin/phpstan

.PHONY: run
run:
	$(COMPOSE) up

build:
	$(COMPOSE) rm -vsf
	$(COMPOSE) down -v --remove-orphans
	$(COMPOSE) build $(DOCKER_APP)

pull:
	$(COMPOSE) pull	

dev:
	$(COMPOSE) run $(DOCKER_APP) bash -c "cd $(ROOT) && $(COMPOSER) install --optimize-autoloader"

prod:
	$(COMPOSE) run $(DOCKER_APP) bash -c "cd $(ROOT) && $(COMPOSER) install --no-dev --optimize-autoloader"

jumpin:
	$(COMPOSE) run $(DOCKER_APP) bash

stan: dev
	$(COMPOSE) run $(DOCKER_APP) bash -c "cd $(ROOT) && $(STAN) analyze $(FILE) --level 7"

style: dev
	$(COMPOSE) run $(DOCKER_APP) bash -c "cd $(ROOT) && $(CSFIXER) fix $(FILE)"

test: dev
	$(COMPOSE) run $(DOCKER_APP) bash -c "cd $(ROOT) && $(PHPUNIT) --bootstrap vendor/autoload.php --testdox tests"

down:
	$(COMPOSE) down --volumes

clean:
	$(COMPOSE) down --volumes --rmi=all
