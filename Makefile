ENV=local
dir=${CURDIR}
project=-p laravel
service=laravel:latest

start:
	@docker-compose -f docker-compose.yml $(project) up -d

start-ci:
	@docker-compose -f docker-compose-ci.yml $(project) up -d

start-prod:
	@docker-compose -f docker-compose-prod.yml $(project) up -d

stop:
	@docker-compose -f docker-compose.yml $(project) down

stop-ci:
	@docker-compose -f docker-compose-ci.yml $(project) down

stop-prod:
	@docker-compose -f docker-compose-prod.yml $(project) down

restart: stop start
restart-ci: stop-ci start-ci
restart-prod: stop-prod start-prod

env-local:
	cp ./.env.local ./.env

env-prod:
	cp ./.env.prod ./.env

ssh:
	@docker-compose $(project) exec laravel bash

ssh-supervisord:
	@docker-compose $(project) exec supervisord bash

exec:
	@docker-compose $(project) exec laravel $$cmd

clean:
	rm -rf $(dir)/reports

prepare:
	mkdir $(dir)/reports
	mkdir $(dir)/reports/coverage

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

drop-migrate:
	@make exec cmd="php artisan migrate:fresh"
	@make exec cmd="php artisan migrate:fresh --env=testing"

migrate:
	@make exec cmd="php artisan migrate --force"
	@make exec cmd="php artisan migrate --force --env=testing"

seed:
	@make exec cmd="php artisan db:seed --force"

phpunit:
	@make exec cmd="vendor/bin/phpunit -c phpunit.xml --log-junit reports/phpunit.xml --coverage-html reports/coverage --coverage-clover reports/coverage.xml"
