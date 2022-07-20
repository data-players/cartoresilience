.DEFAULT_GOAL := help
.PHONY: docker-build docker-up build start log stop restart

DOCKER_COMPOSE=docker-compose -f docker-compose.yaml
DOCKER_COMPOSE_PROD=docker-compose -f docker-compose-prod.yaml
DOCKER_COMPOSE_TEST=docker-compose -f docker-compose-test.yaml
path-cron = $(shell pwd)/compact-cron.sh
path-cron-prod = $(shell pwd)/compact-cron-prod.sh

# Docker
docker-build:
	$(DOCKER_COMPOSE) build

docker-build-prod:
	$(DOCKER_COMPOSE_PROD) build

docker-up:
	$(DOCKER_COMPOSE) up -d

docker-stop:
	$(DOCKER_COMPOSE) kill
	$(DOCKER_COMPOSE) rm -fv

docker-stop-prod:
		$(DOCKER_COMPOSE_PROD) kill
		$(DOCKER_COMPOSE_PROD) rm -fv

docker-clean:
	$(DOCKER_COMPOSE) kill
	$(DOCKER_COMPOSE) rm -fv

docker-start:
	$(DOCKER_COMPOSE) up -d --force-recreate

docker-start-prod-fuseki:
	$(DOCKER_COMPOSE_PROD) up -d --force-recreate fuseki

remove-secure-dataset:
	sudo rm -rf data/fuseki/databases/localData/
	sudo rm -rf data/fuseki/databases/aclData/

docker-start-prod:
	$(DOCKER_COMPOSE_PROD) up -d --force-recreate middleware

docker-restart:
	$(DOCKER_COMPOSE) up -d --force-recreate

log:
	$(DOCKER_COMPOSE) logs -f middleware frontend fuseki traefik

log-prod:
	$(DOCKER_COMPOSE_PROD) logs -f middleware traefik

start: docker-start

start-prod: docker-start-prod

start-prod-complete:
	make docker-start-prod-fuseki
	make docker-start-prod

stop: docker-stop

stop-prod: docker-stop-prod

restart: docker-restart

init :
	make install
	make bootstrap

install :
	npm install --prefix ./client
	npm install --prefix ./server

build:docker-build

build-prod: docker-build-prod

prettier:
	npm run prettier --prefix ./client
	npm run prettier --prefix ./server

bootstrap:
	npm run bootstrap --prefix ./src/frontend
	npm run bootstrap --prefix ./src/middleware

set-compact-cron: 
	(crontab -l 2>/dev/null; echo "0 4 * * * $(path-cron) >> /tmp/cronlog.txt") | crontab -

set-compact-cron-prod: 
	(crontab -l 2>/dev/null; echo "0 4 * * * $(path-cron-prod) >> /tmp/cronlog.txt") | crontab -

# For tests we currently only need fuseki
test:
	$(DOCKER_COMPOSE_TEST) build
	$(DOCKER_COMPOSE_TEST) up -d
	npm run test --prefix ./src/middleware/tests/
	$(DOCKER_COMPOSE_TEST) down
