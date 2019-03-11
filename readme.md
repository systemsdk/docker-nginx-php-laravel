# PHP Laravel environment
Docker environment required to run Laravel (based on official php and mysql docker hub repositories).

[![CircleCI](https://circleci.com/gh/dimadeush/docker-nginx-php-laravel.svg?style=svg)](https://circleci.com/gh/dimadeush/docker-nginx-php-laravel)

[Source code](https://github.com/dimadeush/docker-nginx-php-laravel.git)

## Requirements
* Docker version 18.06 or later
* Docker compose version 1.22 or later
* An editor or IDE
* MySQL Workbench

Note: OS recommendation - Linux Ubuntu based.

## Components:
1. Nginx 1.15
2. PHP 7.3 fpm
3. MySQL 8
4. Laravel 5.8

## Setting up DEV environment
1. Build and start the image from your terminal:
    ```
    docker-compose build
    make start
    make composer-install
    ```
2. Add domain to local 'hosts' file:
    ```
    127.0.0.1    localhost
    ```
3. Set key for application:
    ```
    make ssh
    php artisan key:generate
    ```
4. Make sure that you have installed migrations/seeds:
    ```
    make migrate
    make seed
    ```
5. Configure Xdebug:
    - In case you need debug only requests from frontend in Firefox:
        * Edit /docker/dev/xdebug.ini:
        ```
        xdebug.remote_autostart = 0
        ```
        * Restart container
        * Install locally in Firefox extension "Xdebug helper" and set in settings IDE KEY: PHPSTORM
        * Have fun with debugging
    - In case you need debug any request to an api:
        * Edit /docker/dev/xdebug.ini:
        ```
        xdebug.remote_autostart = 1
        ```
        * Restart container
        * Have fun with debugging

## Additional main command available:
    ```
    make start
    make start-test
    make start-prod
    
    make stop
    make stop-test
    make stop-prod
    
    make restart
    make restart-test
    make restart-prod
    
    make env-test-ci
    
    make ssh
    make ssh-supervisord
    
    make composer-install-prod
    make composer-install
    
    make composer-update
    
    make info
    
    make logs-supervisord
    
    make drop-migrate
    
    make migrate-prod
    make migrate
    
    make seed
    
    make phpunit
    
    etc....
    ```
    Notes: Please see more commands in Makefile

## Architecture & packages
* [Laravel 5.8](https://laravel.com)
* [laravel-migrations-organiser](https://github.com/JayBizzle/Laravel-Migrations-Organiser)
* [phpunit](https://phpunit.de/)
* [phpunit-result-printer](https://github.com/mikeerickson/phpunit-pretty-result-printer)
* [laravel-ide-helper](https://github.com/barryvdh/laravel-ide-helper)
* [scriptsdev](https://github.com/neronmoon/scriptsdev)

## General guidelines
* **[General](docs/general.md)**

## Working on your project
1. For new feature development, fork `develop` branch into a new branch with one of the two patterns:
    * `feature/{ticketNo}`
2. Commit often, and write descriptive commit messages, so its easier to follow steps taken when reviewing.
3. Push this branch to the repo and create pull request into `develop` to get feedback, with the format `feature/{ticketNo}` - Short descriptive title of Jira task".
4. Iterate as needed.
5. Make sure that "All checks have passed" on circleci and status is green.
6. When PR is approved, it will be squashed & merged, into `develop` and later merged into `release/{No}` for deployment.
