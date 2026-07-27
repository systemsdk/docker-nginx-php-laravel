export COMPOSE_PROJECT_NAME=environment3
export NGINX_VERSION=1.29
export WEB_PORT_HTTP=80
export WEB_PORT_SSL=443
export XDEBUG_CONFIG=main
export XDEBUG_VERSION=3.5.3
export MYSQL_VERSION=8.4.8
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

help: ## Show available commands and their descriptions
	@echo "\033[34mList of available commands:\033[39m"
	@grep -E '^[a-zA-Z-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "[32m%-27s[0m %s\n", $$1, $$2}'

export HOST_UID HOST_GID NGINX_VERSION WEB_PORT_HTTP WEB_PORT_SSL XDEBUG_CONFIG XDEBUG_VERSION MYSQL_VERSION INNODB_USE_NATIVE_AIO SQL_MODE MYSQL_ROOT_PASSWORD MYSQL_PORT

build: ## Build the development environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-test: ## Build the test or CI environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-test-ci.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-staging: ## Build the staging environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-staging.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-prod: ## Build the production environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-prod.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

start: ## Start the development environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-test: ## Start the test or CI environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-test-ci.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-staging: ## Start the staging environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-staging.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-prod: ## Start the production environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-prod.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop: ## Stop the development environment containers (without removing them)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-test: ## Stop the test or CI environment containers (without removing them)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-test-ci.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-staging: ## Stop the staging environment containers (without removing them)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-staging.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-prod: ## Stop the production environment containers (without removing them)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-prod.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

down: ## Stop and remove the development environment containers and networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

down-test: ## Stop and remove the test or CI environment containers and networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-test-ci.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

down-staging: ## Stop and remove the staging environment containers and networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-staging.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

down-prod: ## Stop and remove the production environment containers and networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-prod.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

restart: stop start ## Restart the development environment
restart-test: stop-test start-test ## Restart the test or CI environment
restart-staging: stop-staging start-staging ## Restart the staging environment
restart-prod: stop-prod start-prod ## Restart the production environment

env-dev: ## Create config for the dev environment
	@make exec cmd="cp ./.env.dev ./.env"

env-test-ci: ## Create config for test/ci environment
	@make exec cmd="cp ./.env.test-ci ./.env"

ssh: ## Access the bash shell inside the laravel container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) laravel bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-root: ## Access the bash shell as root inside the laravel container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) laravel bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

fish: ## Access the fish shell inside the laravel container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) laravel fish
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-nginx: ## Access the bash shell inside the nginx container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec nginx /bin/sh
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-supervisord: ## Access the bash shell inside the supervisord container (cron jobs, etc.)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec supervisord bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-mysql: ## Access the bash shell inside the mysql container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec mysql bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

exec:
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@$$cmd
else
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) laravel $$cmd
endif

exec-bash:
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@bash -c "$(cmd)"
else
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) laravel bash -c "$(cmd)"
endif

exec-by-root:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) laravel $$cmd
else
	$(ERROR_ONLY_FOR_HOST)
endif

report-prepare: ## Create the /reports/coverage folder (used for test reports)
	@make exec cmd="mkdir -p reports/coverage"

report-clean: ## Remove all generated reports in the /reports/ folder
	@make exec-by-root cmd="rm -rf reports/*"

wait-for-db: ## Check MySQL database availability (useful for CI/CD, e.g. /.circleci)
	@make exec cmd="php artisan db:wait"

composer-install-no-dev: ## Install Composer dependencies (excluding dev packages)
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader --no-dev"

composer-install: ## Install all Composer dependencies
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader"

composer-update: ## Update Composer dependencies
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer update"

composer-audit: ## Check installed packages for security vulnerabilities
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer audit --abandoned=report"

key-generate: ## Set the application key
	@make exec cmd="php artisan key:generate"

info: ## Show the current PHP and Laravel version
	@make exec cmd="php artisan --version"
	@make exec cmd="php artisan env"
	@make exec cmd="php --version"
	@make exec cmd="composer --version"

logs: ## View logs from the laravel container (use ctrl+c to exit)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-laravel
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-nginx: ## View logs from the nginx container (use ctrl+c to exit)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-nginx
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-supervisord: ## View logs from the supervisord container (use ctrl+c to exit)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-supervisord
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-mysql: ## View logs from the mysql container (use ctrl+c to exit)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-mysql
else
	$(ERROR_ONLY_FOR_HOST)
endif

drop-migrate: ## Drop databases and run all migrations for main/test databases
	@make exec cmd="php artisan migrate:fresh"
	@make exec cmd="php artisan migrate:fresh --env=test"

migrate-no-test: ## Run all migrations for the main database only
	@make exec cmd="php artisan migrate --force"

migrate: ## Run all migrations for main/test databases
	@make exec cmd="php artisan migrate --force"
	@make exec cmd="php artisan migrate --force --env=test"

seed: ## Run all seeds for the test database
	@make exec cmd="php artisan db:seed --force"

phpunit: ## Run the PHPUnit test suite
	@make exec-bash cmd="./vendor/bin/phpunit -c phpunit.xml --coverage-html reports/coverage $(PHPUNIT_OPTIONS) --coverage-clover reports/clover.xml --log-junit reports/junit.xml"

report-code-coverage: ## Update code coverage report on Coveralls.io (requires COVERALLS_REPO_TOKEN, should be set on CI side)
	@make exec-bash cmd="export COVERALLS_REPO_TOKEN=${COVERALLS_REPO_TOKEN} && php ./vendor/bin/php-coveralls -v --coverage_clover reports/clover.xml --json_path reports/coverals.json"

phpcs: ## Run PHP CodeSniffer checks
	@make exec-bash cmd="./vendor/bin/phpcs --version && ./vendor/bin/phpcs --standard=PSR12 --colors -p app tests"

ecs: ## Run Easy Coding Standard (ECS) checks
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache check app tests"

ecs-fix: ## Run Easy Coding Standard to automatically fix issues
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache --fix check app tests"

phpmetrics: ## Generate a PhpMetrics static analysis report
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

phpcpd: ## Run PHP Copy/Paste Detector
	@make exec-bash cmd="mkdir -p reports/phpcpd && php ./vendor/bin/phpcpd --fuzzy --verbose --log-pmd=reports/phpcpd/phpcpd-report-v1.xml app tests"

phpcpd-html-report: ## Generate an HTML report for PHP Copy/Paste Detector
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

phpmd: ## Run PHP Mess Detector
	@make exec cmd="php ./vendor/bin/phpmd analyze --format=text --ruleset=phpmd_ruleset.xml --suffixes=php app tests"

phpstan: ## Run PHPStan static analysis
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@echo "\033[32mRunning PHPStan - PHP Static Analysis Tool\033[39m"
	@php artisan cache:clear --env=test
	@./vendor/bin/phpstan --version
	@./vendor/bin/phpstan analyze app tests
else
	@make exec cmd="make phpstan"
endif

phpinsights: ## Run PHP Insights analysis
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@echo "\033[32mRunning PHP Insights\033[39m"
	@php -d error_reporting=0 ./vendor/bin/phpinsights analyse --no-interaction --min-quality=100 --min-complexity=80 --min-architecture=100 --min-style=100
else
	@make exec-by-root cmd="make phpinsights"
endif

composer-normalize: ## Normalize the composer.json file structure
	@make exec cmd="composer normalize"

composer-validate: ## Validate the composer.json file syntax
	@make exec cmd="composer validate --no-check-version"

composer-require-checker: ## Check defined dependencies against actual code usage
	@make exec-bash cmd="XDEBUG_MODE=off php ./vendor/bin/composer-require-checker"

composer-unused: ## Detect unused Composer packages by scanning namespaces
	@make exec-bash cmd="XDEBUG_MODE=off php ./vendor/bin/composer-unused"
