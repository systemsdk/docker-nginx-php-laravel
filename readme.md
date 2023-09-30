# PHP Laravel environment
Docker environment required to run Laravel (based on official php and mysql docker hub repositories).

[![Actions Status](https://github.com/systemsdk/docker-nginx-php-laravel/workflows/Laravel%20App/badge.svg)](https://github.com/systemsdk/docker-nginx-php-laravel/actions)
[![CircleCI](https://circleci.com/gh/systemsdk/docker-nginx-php-laravel.svg?style=svg)](https://circleci.com/gh/systemsdk/docker-nginx-php-laravel)
[![Coverage Status](https://coveralls.io/repos/github/systemsdk/docker-nginx-php-laravel/badge.svg)](https://coveralls.io/github/systemsdk/docker-nginx-php-laravel)
[![Latest Stable Version](https://poser.pugx.org/systemsdk/docker-nginx-php-laravel/v)](https://packagist.org/packages/systemsdk/docker-nginx-php-laravel)
[![Total Downloads](https://poser.pugx.org/systemsdk/docker-nginx-php-laravel/downloads)](https://packagist.org/packages/systemsdk/docker-nginx-php-laravel)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

[Source code](https://github.com/systemsdk/docker-nginx-php-laravel.git)

## Requirements
* Docker version 18.06 or later
* Docker compose version 1.22 or later
* An editor or IDE
* MySQL Workbench

Note: OS recommendation - Linux Ubuntu based.

## Components
1. Nginx 1.25
2. PHP 8.2 fpm
3. MySQL 8
4. Laravel 10
5. Mailpit (only for debug emails on dev environment)

## Setting up Docker and docker-compose
1.For installing Docker please follow steps mentioned on page [install on Ubuntu linux](https://docs.docker.com/install/linux/docker-ce/ubuntu/) or [install on Mac/Windows](https://docs.docker.com/engine/install/).

2.For installing docker-compose as `Linux Standalone binary` please follow steps on the page [install compose](https://docs.docker.com/compose/install/standalone/) if you are using Linux OS.

Note 1: Please run next cmd after above step 2 if you are using Linux OS: `sudo usermod -aG docker $USER`

Note 2: If you are using Docker Desktop for MacOS 12.2 or later - please enable [virtiofs](https://www.docker.com/blog/speed-boost-achievement-unlocked-on-docker-desktop-4-6-for-mac/) for performance (enabled by default since Docker Desktop v4.22).

## Setting up DEV environment
1.You can clone this repository from GitHub or install via composer.

Note: Delete `storage/mysql-data` folder if it is exists.

If you have installed composer and want to install environment via composer you can use next cmd command:
```bash
composer create-project systemsdk/docker-nginx-php-laravel example-app
```

2.Add domain to local `hosts` file:
```bash
127.0.0.1    localhost
```

3.Configure `/docker/dev/xdebug-main.ini` (Linux/Windows) or `/docker/dev/xdebug-osx.ini` (MacOS) (optional):

- In case you need debug only requests with IDE KEY: PHPSTORM from frontend in your browser:
```bash
xdebug.start_with_request = no
```
Install locally in Firefox extension "Xdebug helper" and set in settings IDE KEY: PHPSTORM

- In case you need debug any request to an api (by default):
```bash
xdebug.start_with_request = yes
```

4.Build, start and install the docker images from your terminal:
```bash
make build
make start
make composer-install
make env-dev
```
Note: If you want to change default docker configurations (web_port, etc...) - open `.env` file, edit necessary environment variable value and stop, rebuild, start docker containers.

5.Make sure that you have installed migrations/seeds:
```bash
make migrate
make seed
```

6.Set key for application:
```bash
make key-generate
```

7.In order to use this application, please open in your browser next urls:
- [http://localhost](http://localhost)
- [http://localhost:8025 (Mailpit)](http://localhost:8025)

## Setting up STAGING environment locally
1.You can clone this repository from GitHub or install via composer.

Note: Delete `storage/mysql-data` and `vendor` folder if it is exists.

If you have installed composer and want to install environment via composer you can use next cmd command:
```bash
composer create-project systemsdk/docker-nginx-php-laravel example-app
```
Note: If you want to change default docker configurations (web_port, etc...) - create uncommitted `.env` file, copy data from `.env.staging`, edit necessary environment variable value.

2.Build, start and install the docker images from your terminal:
```bash
make build-staging
make start-staging
```

3.Make sure that you have installed migrations:
```bash
make migrate-no-test
```

4.Set key for application:
```bash
make key-generate
```

## Setting up PROD environment locally
1.You can clone this repository from GitHub or install via composer.

Note: Delete `storage/mysql-data` and `vendor` folder if it is exists.

If you have installed composer and want to install environment via composer you can use next cmd command:
```bash
composer create-project systemsdk/docker-nginx-php-laravel example-app
```

2.Edit `docker-compose-prod.yml` and set necessary user/password for MySQL.

3.Edit `env.prod` and set necessary user/password for MySQL.

Note: If you want to change default docker configurations (web_port, etc...) - create uncommitted `.env` file, copy data from `.env.prod`, edit necessary environment variable value.

4.Build, start and install the docker images from your terminal:
```bash
make build-prod
make start-prod
```

5.Make sure that you have installed migrations:
```bash
make migrate-no-test
```

6.Set key for application:
```bash
make key-generate
```

## Getting shell to container
After application will start (`make start`) and in order to get shell access inside laravel container you can run following command:
```bash
make ssh
```
Note 1: Please use next make commands in order to enter in other containers: `make ssh-nginx`, `make ssh-supervisord`, `make ssh-mysql`.

Note 2: Please use `exit` command in order to return from container's shell to local shell.

## Building containers
In case you edited Dockerfile or other environment configuration you'll need to build containers again using next commands:
```bash
make down
make build
make start
```
Note: Please use environment-specific commands if you need to build test/staging/prod environment, more details can be found using help `make help`.

## Start and stop environment containers
Please use next make commands in order to start and stop environment:
```bash
make start
make stop
```
Note 1: For staging environment need to be used next make commands: `make start-staging`, `make stop-staging`.

Note 2: For prod environment need to be used next make commands: `make start-prod`, `make stop-prod`.

## Stop and remove environment containers, networks
Please use next make commands in order to stop and remove environment containers, networks:
```bash
make down
```
Note: Please use environment-specific commands if you need to stop and remove test/staging/prod environment, more details can be found using help `make help`.

## Additional main command available
```bash
make build
make build-test
make build-staging
make build-prod

make start
make start-test
make start-staging
make start-prod

make stop
make stop-test
make stop-staging
make stop-prod

make down
make down-test
make down-staging
make down-prod

make restart
make restart-test
make restart-staging
make restart-prod

make env-dev
make env-test-ci

make ssh
make ssh-root
make ssh-nginx
make ssh-supervisord
make ssh-mysql

make composer-install-no-dev
make composer-install
make composer-update

make key-generate

make info
make help

make logs
make logs-nginx
make logs-supervisord
make logs-mysql

make drop-migrate
make migrate-no-test
make migrate

make seed

make phpunit
make report-code-coverage

make phpcs
make ecs
make ecs-fix
make phpmetrics
make phpcpd
make phpmd
make phpstan
make phpinsights

etc....
```
Notes: Please see more commands in Makefile

## Architecture & packages
* [Laravel 10](https://laravel.com)
* [laravel-migrations-organiser](https://github.com/JayBizzle/Laravel-Migrations-Organiser)
* [phpunit](https://github.com/sebastianbergmann/phpunit)
* [laravel-ide-helper](https://github.com/barryvdh/laravel-ide-helper)
* [scriptsdev](https://github.com/neronmoon/scriptsdev)
* [composer-bin-plugin](https://github.com/bamarni/composer-bin-plugin)
* [ergebnis/composer-normalize](https://github.com/ergebnis/composer-normalize)
* [composer-unused](https://packagist.org/packages/icanhazstring/composer-unused)
* [composer-require-checker](https://packagist.org/packages/maglnet/composer-require-checker)
* [security-advisories](https://github.com/Roave/SecurityAdvisories)
* [php-coveralls](https://github.com/php-coveralls/php-coveralls)
* [easy-coding-standard](https://github.com/Symplify/EasyCodingStandard)
* [PhpMetrics](https://github.com/phpmetrics/PhpMetrics)
* [phpcpd](https://packagist.org/packages/sebastian/phpcpd)
* [phpmd](https://packagist.org/packages/phpmd/phpmd)
* [phpstan](https://packagist.org/packages/nunomaduro/larastan)
* [phpinsights](https://packagist.org/packages/nunomaduro/phpinsights)
* [rector](https://packagist.org/packages/rector/rector)

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

Note: You can find git flow detail example [here](https://danielkummer.github.io/git-flow-cheatsheet).

## License
[The MIT License (MIT)](LICENSE)
