dir=${CURDIR}
project=-p laravel
service=laravel:latest
interactive:=$(shell [ -t 0 ] && echo 1)
ifneq ($(interactive),1)
	optionT=-T
endif

start:
	@docker-compose -f docker-compose.yml $(project) up -d

start-test:
	@docker-compose -f docker-compose-test-ci.yml $(project) up -d

start-prod:
	@docker-compose -f docker-compose-prod.yml $(project) up -d

stop:
	@docker-compose -f docker-compose.yml $(project) down

stop-test:
	@docker-compose -f docker-compose-test-ci.yml $(project) down

stop-prod:
	@docker-compose -f docker-compose-prod.yml $(project) down

restart: stop start
restart-test: stop-test start-test
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

composer-install-prod:
	@make exec cmd="composer install --no-dev"

composer-install:
	@make exec cmd="composer install"

composer-update:
	@make exec cmd="composer update"

info:
	@make exec cmd="php artisan --version"
	@make exec cmd="php --version"

logs:
	@docker logs -f laravel

logs-nginx:
	@docker logs -f nginx

logs-supervisord:
	@docker logs -f supervisord

logs-mysql:
	@docker logs -f mysql

drop-migrate:
	@make exec cmd="php artisan migrate:fresh"
	@make exec cmd="php artisan migrate:fresh --env=test"

migrate-prod:
	@make exec cmd="php artisan migrate --force"

migrate:
	@make exec cmd="php artisan migrate --force"
	@make exec cmd="php artisan migrate --force --env=test"

seed:
	@make exec cmd="php artisan db:seed --force"

phpunit:
	@make exec cmd="./vendor/bin/phpunit -c phpunit.xml --coverage-html reports/coverage --coverage-clover reports/clover.xml --log-junit reports/junit.xml"

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
