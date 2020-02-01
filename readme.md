# PHP Laravel environment
Docker environment required to run Laravel (based on official php and mysql docker hub repositories).

[![Actions Status](https://github.com/dimadeush/docker-nginx-php-laravel/workflows/Laravel%20App/badge.svg)](https://github.com/dimadeush/docker-nginx-php-laravel/actions)
[![CircleCI](https://circleci.com/gh/dimadeush/docker-nginx-php-laravel.svg?style=svg)](https://circleci.com/gh/dimadeush/docker-nginx-php-laravel)
[![Coverage Status](https://coveralls.io/repos/github/dimadeush/docker-nginx-php-laravel/badge.svg)](https://coveralls.io/github/dimadeush/docker-nginx-php-laravel)

[Source code](https://github.com/dimadeush/docker-nginx-php-laravel.git)

## Requirements
* Docker version 18.06 or later
* Docker compose version 1.22 or later
* An editor or IDE
* MySQL Workbench

Note: OS recommendation - Linux Ubuntu based.

## Components
1. Nginx 1.17
2. PHP 7.4 fpm
3. MySQL 8
4. Laravel 6

## Setting up DEV environment
1.Clone this repository from GitHub.

2.Add domain to local 'hosts' file:
```bash
127.0.0.1    localhost
```

3.Configure `/docker/dev/xdebug.ini` (optional):

- In case you need debug only requests with IDE KEY: PHPSTORM from frontend in your browser:
```bash
xdebug.remote_autostart = 0
```
Install locally in Firefox extension "Xdebug helper" and set in settings IDE KEY: PHPSTORM

- In case you need debug any request to an api (by default):
```bash
xdebug.remote_autostart = 1
```

4.Build and start the image from your terminal:
```bash
docker-compose build
make start
make composer-install
make env-dev
```

5.Set key for application:
```bash
make ssh
php artisan key:generate
```

6.Make sure that you have installed migrations/seeds:
```bash
make migrate
make seed
```

## Additional main command available
```bash
make start
make start-test
make start-prod

make stop
make stop-test
make stop-prod

make restart
make restart-test
make restart-prod

make env-dev
make env-test-ci

make ssh
make ssh-nginx
make ssh-supervisord
make ssh-mysql

make composer-install-prod
make composer-install

make composer-update

make info

make logs
make logs-nginx
make logs-supervisord
make logs-mysql

make drop-migrate

make migrate-prod
make migrate

make seed

make phpunit
make report-code-coverage

make phpcs
make ecs
make ecs-fix
make phpmetrics

etc....
```
Notes: Please see more commands in Makefile

## Architecture & packages
* [Laravel 6](https://laravel.com)
* [laravel-migrations-organiser](https://github.com/JayBizzle/Laravel-Migrations-Organiser)
* [phpunit](https://github.com/sebastianbergmann/phpunit)
* [laravel-ide-helper](https://github.com/barryvdh/laravel-ide-helper)
* [scriptsdev](https://github.com/neronmoon/scriptsdev)
* [composer-bin-plugin](https://github.com/bamarni/composer-bin-plugin)
* [security-advisories](https://github.com/Roave/SecurityAdvisories)
* [php-coveralls](https://github.com/php-coveralls/php-coveralls)
* [easy-coding-standard](https://github.com/Symplify/EasyCodingStandard)
* [PhpMetrics](https://github.com/phpmetrics/PhpMetrics)

## Guidelines
* [Commands](docs/commands.md)
* [Development](docs/development.md)
* [Testing](docs/testing.md)
* [IDE PhpStorm configuration](docs/phpstorm.md)
* [Xdebug configuration](docs/xdebug.md)

## Working on your project
1. For new feature development, fork `develop` branch into a new branch with one of the two patterns:
    * `feature/{ticketNo}`
2. Commit often, and write descriptive commit messages, so its easier to follow steps taken when reviewing.
3. Push this branch to the repo and create pull request into `develop` to get feedback, with the format `feature/{ticketNo}` - "Short descriptive title of Jira task".
4. Iterate as needed.
5. Make sure that "All checks have passed" on CircleCI(or another one in case you are not using CircleCI) and status is green.
6. When PR is approved, it will be squashed & merged, into `develop` and later merged into `release/{No}` for deployment.
