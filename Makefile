dir=${CURDIR}

ifndef APP_ENV
	include .env
endif

project=-p ${COMPOSE_PROJECT_NAME}
service=${COMPOSE_PROJECT_NAME}:latest
interactive:=$(shell [ -t 0 ] && echo 1)
ifneq ($(interactive),1)
	optionT=-T
endif
ifeq ($(GITLAB_CI),1)
	# Determine additional params for phpunit in order to generate coverage badge on GitLabCI side
	phpunitOptions=--coverage-text --colors=never
endif

build:
	@docker-compose -f docker-compose.yml build

build-test:
	@docker-compose -f docker-compose-test-ci.yml build

build-staging:
	@docker-compose -f docker-compose-staging.yml build

build-prod:
	@docker-compose -f docker-compose-prod.yml build

start:
	@docker-compose -f docker-compose.yml $(project) up -d

start-test:
	@docker-compose -f docker-compose-test-ci.yml $(project) up -d

start-staging:
	@docker-compose -f docker-compose-staging.yml $(project) up -d

start-prod:
	@docker-compose -f docker-compose-prod.yml $(project) up -d

stop:
	@docker-compose -f docker-compose.yml $(project) down

stop-test:
	@docker-compose -f docker-compose-test-ci.yml $(project) down

stop-staging:
	@docker-compose -f docker-compose-staging.yml $(project) down

stop-prod:
	@docker-compose -f docker-compose-prod.yml $(project) down

restart: stop start
restart-test: stop-test start-test
restart-staging: stop-staging start-staging
restart-prod: stop-prod start-prod

env-dev:
	@make exec cmd="cp ./.env.dev ./.env"

env-test-ci:
	@make exec cmd="cp ./.env.test-ci ./.env"

ssh:
	@docker-compose $(project) exec $(optionT) laravel bash

ssh-nginx:
	@docker-compose $(project) exec nginx /bin/sh

ssh-supervisord:
	@docker-compose $(project) exec supervisord bash

ssh-mysql:
	@docker-compose $(project) exec mysql bash

exec:
	@docker-compose $(project) exec $(optionT) laravel $$cmd

exec-bash:
	@docker-compose $(project) exec $(optionT) laravel bash -c "$(cmd)"

report-prepare:
	mkdir -p $(dir)/reports/coverage

report-clean:
	rm -rf $(dir)/reports/*

wait-for-db:
	@make exec cmd="php artisan db:wait"

composer-install-no-dev:
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader --no-dev"

composer-install:
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader"

composer-update:
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer update"

key-generate:
	@make exec cmd="php artisan key:generate"

info:
	@make exec cmd="php artisan --version"
	@make exec cmd="php artisan env"
	@make exec cmd="php --version"

logs:
	@docker logs -f ${COMPOSE_PROJECT_NAME}_laravel

logs-nginx:
	@docker logs -f ${COMPOSE_PROJECT_NAME}_nginx

logs-supervisord:
	@docker logs -f ${COMPOSE_PROJECT_NAME}_supervisord

logs-mysql:
	@docker logs -f ${COMPOSE_PROJECT_NAME}_mysql

drop-migrate:
	@make exec cmd="php artisan migrate:fresh"
	@make exec cmd="php artisan migrate:fresh --env=test"

migrate-no-test:
	@make exec cmd="php artisan migrate --force"

migrate:
	@make exec cmd="php artisan migrate --force"
	@make exec cmd="php artisan migrate --force --env=test"

seed:
	@make exec cmd="php artisan db:seed --force"

phpunit:
	@make exec cmd="./vendor/bin/phpunit -c phpunit.xml --coverage-html reports/coverage $(phpunitOptions) --coverage-clover reports/clover.xml --log-junit reports/junit.xml"

###> php-coveralls ###
report-code-coverage: ## update code coverage on coveralls.io. Note: COVERALLS_REPO_TOKEN should be set on CI side.
	@make exec-bash cmd="export COVERALLS_REPO_TOKEN=${COVERALLS_REPO_TOKEN} && php ./vendor/bin/php-coveralls -v --coverage_clover reports/clover.xml --json_path reports/coverals.json"
###< php-coveralls ###

###> phpcs ###
phpcs: ## Run PHP CodeSniffer
	@make exec-bash cmd="./vendor/bin/phpcs --version && ./vendor/bin/phpcs --standard=PSR2 --colors -p app"
###< phpcs ###

###> ecs ###
ecs: ## Run Easy Coding Standard
	@make exec-bash cmd="error_reporting=0 ./vendor/bin/ecs --clear-cache check app"

ecs-fix: ## Run The Easy Coding Standard to fix issues
	@make exec-bash cmd="error_reporting=0 ./vendor/bin/ecs --clear-cache --fix check app"
###< ecs ###

###> phpmetrics ###
phpmetrics:
	@make exec cmd="make phpmetrics-process"

phpmetrics-process: ## Generates PhpMetrics static analysis, should be run inside symfony container
	@mkdir -p reports/phpmetrics
	@if [ ! -f reports/junit.xml ] ; then \
		printf "\033[32;49mjunit.xml not found, running tests...\033[39m\n" ; \
		./vendor/bin/phpunit -c phpunit.xml --coverage-html reports/coverage --coverage-clover reports/clover.xml --log-junit reports/junit.xml ; \
	fi;
	@echo "\033[32mRunning PhpMetrics\033[39m"
	@php ./vendor/bin/phpmetrics --version
	@./vendor/bin/phpmetrics --junit=reports/junit.xml --report-html=reports/phpmetrics .
###< phpmetrics ###
