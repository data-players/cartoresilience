.DEFAULT_GOAL := help
.PHONY: docker-build docker-up build start log stop restart

DOCKER_COMPOSE_LOCAL=docker-compose -f docker-compose-local.yaml
DOCKER_COMPOSE_PROD=docker-compose -f docker-compose-prod.yaml
DOCKER_COMPOSE_TEST=docker-compose -f docker-compose-test.yaml
path-cron-local = $(shell pwd)/compact-cron-local.sh
path-cron-prod = $(shell pwd)/compact-cron-prod.sh

# Docker
docker-build-local:
	$(DOCKER_COMPOSE_LOCAL) build

docker-build-prod:
	$(DOCKER_COMPOSE_PROD) build

docker-up-local:
	$(DOCKER_COMPOSE_LOCAL) up -d

docker-stop-local:
	$(DOCKER_COMPOSE_LOCAL) kill
	$(DOCKER_COMPOSE_LOCAL) rm -fv

docker-stop-prod:
		$(DOCKER_COMPOSE_PROD) kill
		$(DOCKER_COMPOSE_PROD) rm -fv

docker-clean-local:
	$(DOCKER_COMPOSE_LOCAL) kill
	$(DOCKER_COMPOSE_LOCAL) rm -fv

docker-start-local:
	$(DOCKER_COMPOSE_LOCAL) up -d --force-recreate

docker-start-prod-fuseki:
	$(DOCKER_COMPOSE_PROD) up -d --force-recreate fuseki

remove-secure-dataset:
	sudo rm -rf data/fuseki/databases/localData/
	sudo rm -rf data/fuseki/databases/aclData/

docker-start-prod:
	$(DOCKER_COMPOSE_PROD) up -d --force-recreate

docker-restart-local:
	$(DOCKER_COMPOSE_LOCAL) up -d --force-recreate

log-local:
	$(DOCKER_COMPOSE_LOCAL) logs -f middleware frontend fuseki traefik

log-prod:
	$(DOCKER_COMPOSE_PROD) logs -f middleware traefik

compact-local: 
	$(DOCKER_COMPOSE_LOCAL) down && $(DOCKER_COMPOSE_LOCAL) up fuseki_compact && $(DOCKER_COMPOSE_LOCAL) up -d

compact-prod:
	$(DOCKER_COMPOSE_PROD) down && $(DOCKER_COMPOSE_PROD) up fuseki_compact && $(DOCKER_COMPOSE_PROD) up -d

start-local: docker-start-local

start-prod: docker-start-prod

start-prod-complete:
	make docker-start-prod-fuseki
	make docker-start-prod

stop-local: docker-stop-local

stop-prod: docker-stop-prod

restart-local: docker-restart-local

init :
	make install
	make bootstrap

install :
	npm install --prefix ./client
	npm install --prefix ./server

build-local:docker-build-local

build-prod: docker-build-prod

prettier:
	npm run prettier --prefix ./client
	npm run prettier --prefix ./server

bootstrap:
	npm run bootstrap --prefix ./src/frontend
	npm run bootstrap --prefix ./src/middleware

set-compact-cron-local: 
	(crontab -l 2>/dev/null; echo "0 4 * * * $(path-cron-local) >> /tmp/cronlog.txt") | crontab -

set-compact-cron-prod: 
	(crontab -l 2>/dev/null; echo "0 4 * * * $(path-cron-prod) >> /tmp/cronlog.txt") | crontab -

# For tests we currently only need fuseki
test:
	$(DOCKER_COMPOSE_TEST) build
	$(DOCKER_COMPOSE_TEST) up -d
	npm run test --prefix ./src/middleware/tests/
	$(DOCKER_COMPOSE_TEST) down
