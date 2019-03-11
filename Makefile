dir=${CURDIR}
project=-p laravel
service=laravel:latest

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

env-test-ci:
	@make exec cmd="cp ./.env.test-ci ./.env"

ssh:
	@docker-compose $(project) exec laravel bash

ssh-supervisord:
	@docker-compose $(project) exec supervisord bash

exec:
	@docker-compose $(project) exec laravel $$cmd

clean:
	rm -rf $(dir)/reports/*

prepare:
	mkdir -p $(dir)/reports/coverage

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

logs-supervisord:
	@docker logs supervisord

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
	@make exec cmd="vendor/bin/phpunit -c phpunit.xml --log-junit reports/phpunit.xml --coverage-html reports/coverage --coverage-clover reports/coverage.xml"
