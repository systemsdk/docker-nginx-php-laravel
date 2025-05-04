export COMPOSE_PROJECT_NAME=environment3
export WEB_PORT_HTTP=80
export WEB_PORT_SSL=443
export XDEBUG_CONFIG=main
export XDEBUG_VERSION=3.4.2
export MYSQL_VERSION=8.4.4
export INNODB_USE_NATIVE_AIO=1
export SQL_MODE=ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
export MYSQL_ROOT_PASSWORD=secret
export MYSQL_PORT=33061

# Determine if .env file exist
ifneq ("$(wildcard .env)","")
	include .env
endif

ifndef INSIDE_DOCKER_CONTAINER
	INSIDE_DOCKER_CONTAINER = 0
endif

HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)
PHP_USER := -u www-data
PROJECT_NAME := -p ${COMPOSE_PROJECT_NAME}
INTERACTIVE := $(shell [ -t 0 ] && echo 1)
ERROR_ONLY_FOR_HOST = @printf "\033[33mThis command for host machine\033[39m\n"
.DEFAULT_GOAL := help
ifneq ($(INTERACTIVE), 1)
	OPTION_T := -T
endif
ifeq ($(GITLAB_CI), 1)
	# Determine additional params for phpunit in order to generate coverage badge on GitLabCI side
	PHPUNIT_OPTIONS := --coverage-text --colors=never
endif

help: ## Shows available commands with description
	@echo "\033[34mList of available commands:\033[39m"
	@grep -E '^[a-zA-Z-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "[32m%-27s[0m %s\n", $$1, $$2}'

build: ## Build dev environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose -f compose.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-test: ## Build test or continuous integration environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose -f compose-test-ci.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-staging: ## Build staging environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) docker compose -f compose-staging.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-prod: ## Build prod environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) docker compose -f compose-prod.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

start: ## Start dev environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose -f compose.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-test: ## Start test or continuous integration environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose -f compose-test-ci.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-staging: ## Start staging environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) docker compose -f compose-staging.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-prod: ## Start prod environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) docker compose -f compose-prod.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop: ## Stop dev environment containers
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose -f compose.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-test: ## Stop test or continuous integration environment containers
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose -f compose-test-ci.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-staging: ## Stop staging environment containers
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) docker compose -f compose-staging.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-prod: ## Stop prod environment containers
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) docker compose -f compose-prod.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

down: ## Stop and remove dev environment containers, networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose -f compose.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

down-test: ## Stop and remove test or continuous integration environment containers, networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose -f compose-test-ci.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

down-staging: ## Stop and remove staging environment containers, networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) docker compose -f compose-staging.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

down-prod: ## Stop and remove prod environment containers, networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) docker compose -f compose-prod.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

restart: stop start ## Stop and start dev environment
restart-test: stop-test start-test ## Stop and start test or continuous integration environment
restart-staging: stop-staging start-staging ## Stop and start staging environment
restart-prod: stop-prod start-prod ## Stop and start prod environment

env-dev: ## Creates config for dev environment
	@make exec cmd="cp ./.env.dev ./.env"

env-test-ci: ## Creates config for test/ci environment
	@make exec cmd="cp ./.env.test-ci ./.env"

ssh: ## Get bash inside laravel docker container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) laravel bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-root: ## Get bash as root user inside laravel docker container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose $(PROJECT_NAME) exec $(OPTION_T) laravel bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

fish: ## Get fish shell inside laravel docker container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) laravel fish
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-nginx: ## Get bash inside nginx docker container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose $(PROJECT_NAME) exec nginx /bin/sh
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-supervisord: ## Get bash inside supervisord docker container (cron jobs running there, etc...)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose $(PROJECT_NAME) exec supervisord bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-mysql: ## Get bash inside mysql docker container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose $(PROJECT_NAME) exec mysql bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

exec:
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@$$cmd
else
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) laravel $$cmd
endif

exec-bash:
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@bash -c "$(cmd)"
else
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) laravel bash -c "$(cmd)"
endif

exec-by-root:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) WEB_PORT_HTTP=$(WEB_PORT_HTTP) WEB_PORT_SSL=$(WEB_PORT_SSL) XDEBUG_CONFIG=$(XDEBUG_CONFIG) XDEBUG_VERSION=$(XDEBUG_VERSION) MYSQL_VERSION=$(MYSQL_VERSION) INNODB_USE_NATIVE_AIO=$(INNODB_USE_NATIVE_AIO) SQL_MODE=$(SQL_MODE) MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) MYSQL_PORT=$(MYSQL_PORT) docker compose $(PROJECT_NAME) exec $(OPTION_T) laravel $$cmd
else
	$(ERROR_ONLY_FOR_HOST)
endif

report-prepare:
	@make exec cmd="mkdir -p reports/coverage"

report-clean:
	@make exec-by-root cmd="rm -rf reports/*"

wait-for-db:
	@make exec cmd="php artisan db:wait"

composer-install-no-dev: ## Installs composer no-dev dependencies
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader --no-dev"

composer-install: ## Installs composer dependencies
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader"

composer-update: ## Updates composer dependencies
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer update"

composer-audit: ## Checks for security vulnerability advisories for installed packages
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer audit"

key-generate: ## Sets the application key
	@make exec cmd="php artisan key:generate"

info: ## Shows Php and Laravel version
	@make exec cmd="php artisan --version"
	@make exec cmd="php artisan env"
	@make exec cmd="php --version"
	@make exec cmd="composer --version"

logs: ## Shows logs from the laravel container. Use ctrl+c in order to exit
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-laravel
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-nginx: ## Shows logs from the nginx container. Use ctrl+c in order to exit
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-nginx
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-supervisord: ## Shows logs from the supervisord container. Use ctrl+c in order to exit
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-supervisord
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-mysql: ## Shows logs from the mysql container. Use ctrl+c in order to exit
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-mysql
else
	$(ERROR_ONLY_FOR_HOST)
endif

drop-migrate: ## Drops databases and runs all migrations for the main/test databases
	@make exec cmd="php artisan migrate:fresh"
	@make exec cmd="php artisan migrate:fresh --env=test"

migrate-no-test: ## Runs all migrations for main database
	@make exec cmd="php artisan migrate --force"

migrate: ## Runs all migrations for main/test databases
	@make exec cmd="php artisan migrate --force"
	@make exec cmd="php artisan migrate --force --env=test"

seed: ## Runs all seeds for test database
	@make exec cmd="php artisan db:seed --force"

phpunit: ## Runs PhpUnit tests
	@make exec cmd="./vendor/bin/phpunit -c phpunit.xml --coverage-html reports/coverage $(PHPUNIT_OPTIONS) --coverage-clover reports/clover.xml --log-junit reports/junit.xml"

report-code-coverage: ## Updates code coverage on coveralls.io. Note: COVERALLS_REPO_TOKEN should be set on CI side.
	@make exec-bash cmd="export COVERALLS_REPO_TOKEN=${COVERALLS_REPO_TOKEN} && php ./vendor/bin/php-coveralls -v --coverage_clover reports/clover.xml --json_path reports/coverals.json"

phpcs: ## Runs PHP CodeSniffer
	@make exec-bash cmd="./vendor/bin/phpcs --version && ./vendor/bin/phpcs --standard=PSR12 --colors -p app tests"

ecs: ## Runs Easy Coding Standard tool
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache check app tests"

ecs-fix: ## Runs Easy Coding Standard tool to fix issues
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache --fix check app tests"

phpmetrics: ## Generates phpmetrics static analysis report
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@mkdir -p reports/phpmetrics
	@if [ ! -f reports/junit.xml ] ; then \
		printf "\033[32;49mjunit.xml not found, running tests...\033[39m\n" ; \
		./vendor/bin/phpunit -c phpunit.xml --coverage-html reports/coverage --coverage-clover reports/clover.xml --log-junit reports/junit.xml ; \
	fi;
	@echo "\033[32mRunning PhpMetrics\033[39m"
	@php ./vendor/bin/phpmetrics --version
	@php ./vendor/bin/phpmetrics --junit=reports/junit.xml --report-html=reports/phpmetrics .
else
	@make exec-by-root cmd="make phpmetrics"
endif

phpcpd: ## Runs php copy/paste detector
	@make exec-bash cmd="mkdir -p reports/phpcpd && php ./vendor/bin/phpcpd --fuzzy --verbose --log-pmd=reports/phpcpd/phpcpd-report-v1.xml app tests"

phpcpd-html-report: ## Generates phpcpd html report
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@if [ ! -f reports/phpcpd/phpcpd-report-v1.xml ] ; then \
		printf "\033[32;49mreports/phpcpd/phpcpd-report-v1.xml not found, please run phpcpd.\033[39m\n" ; \
	else \
		printf "\033[32;49mCreating reports/phpcpd/phpcpd-report-v1.html report...\033[39m\n" ; \
		xalan -in reports/phpcpd/phpcpd-report-v1.xml -xsl https://systemsdk.github.io/phpcpd/report/phpcpd-html-v1_0_0.xslt -out reports/phpcpd/phpcpd-report-v1.html ; \
	fi;
else
	@make exec-bash cmd="make phpcpd-html-report"
endif

phpmd: ## Runs php mess detector
	@make exec cmd="php ./vendor/bin/phpmd app,tests text phpmd_ruleset.xml --suffixes php"

phpstan: ## Runs PhpStan static analysis tool
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@echo "\033[32mRunning PHPStan - PHP Static Analysis Tool\033[39m"
	@php artisan cache:clear --env=test
	@./vendor/bin/phpstan --version
	@./vendor/bin/phpstan analyze app tests
else
	@make exec cmd="make phpstan"
endif

phpinsights: ## Runs Php Insights analysis tool
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@echo "\033[32mRunning PHP Insights\033[39m"
	@php -d error_reporting=0 ./vendor/bin/phpinsights analyse --no-interaction --min-quality=100 --min-complexity=80 --min-architecture=100 --min-style=100
else
	@make exec-by-root cmd="make phpinsights"
endif

composer-normalize: ## Normalizes composer.json file content
	@make exec cmd="composer normalize"

composer-validate: ## Validates composer.json file content
	@make exec cmd="composer validate --no-check-version"

composer-require-checker: ## Checks the defined dependencies against your code
	@make exec-bash cmd="XDEBUG_MODE=off php ./vendor/bin/composer-require-checker"

composer-unused: ## Shows unused packages by scanning and comparing package namespaces against your code
	@make exec-bash cmd="XDEBUG_MODE=off php ./vendor/bin/composer-unused"
