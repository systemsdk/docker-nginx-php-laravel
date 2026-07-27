# PHP Laravel Environment
A scalable Docker-based environment required to run Laravel (based on official php and mysql docker hub repositories).

[![Actions Status](https://github.com/systemsdk/docker-nginx-php-laravel/workflows/Laravel%20App/badge.svg)](https://github.com/systemsdk/docker-nginx-php-laravel/actions)
[![CircleCI](https://circleci.com/gh/systemsdk/docker-nginx-php-laravel.svg?style=svg)](https://circleci.com/gh/systemsdk/docker-nginx-php-laravel)
[![Coverage Status](https://coveralls.io/repos/github/systemsdk/docker-nginx-php-laravel/badge.svg)](https://coveralls.io/github/systemsdk/docker-nginx-php-laravel)
[![Latest Stable Version](https://poser.pugx.org/systemsdk/docker-nginx-php-laravel/v)](https://packagist.org/packages/systemsdk/docker-nginx-php-laravel)
[![Total Downloads](https://poser.pugx.org/systemsdk/docker-nginx-php-laravel/downloads)](https://packagist.org/packages/systemsdk/docker-nginx-php-laravel)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

[Source code](https://github.com/systemsdk/docker-nginx-php-laravel.git)

## Requirements
* Docker Engine version 23.0 or later
* Docker Compose version 2.0 or later
* An editor or IDE
* MySQL Workbench

Note: We recommend using a Linux Ubuntu-based OS for the best experience.

## Components
1. Nginx 1.29 - Web server and reverse proxy.
2. PHP 8.5 fpm - Main application runtime.
3. MySQL 8 - Primary relational database.
4. Laravel 13 - High-performance PHP framework.
5. Mailpit - Email testing tool (available in the development environment only).

## Setting up Docker Engine & Docker Compose
To install Docker Engine and Docker Compose, please follow the official [Docker Engine Installation Guide](https://docs.docker.com/engine/install/).

**For Linux Users:**
After installation, run the following command to manage Docker as a non-root user (this allows you to run Docker without `sudo`):
```bash
sudo usermod -aG docker $USER
```

Note: You must log out and log back in for this change to take effect.

**For macOS Users:**
If you are using Docker Desktop for macOS 12.2 or later, we highly recommend enabling [virtiofs](https://www.docker.com/blog/speed-boost-achievement-unlocked-on-docker-desktop-4-6-for-mac/) for a significant performance boost.

Note: Enabled by default since Docker Desktop v4.22.

## Setting up the DEV environment
1. You can clone this repository from GitHub or install via composer.

   Note: Delete the `storage/mysql-data` folder if it exists before starting.

   If you have installed composer, you can use the next cmd command:
   ```bash
   composer create-project systemsdk/docker-nginx-php-laravel example-app
   ```

2. Verify that your local `hosts` file contains the default mapping for `localhost` (this is usually set by default in all operating systems):
   ```text
   127.0.0.1    localhost
   ```

   Note: The file is located at `/etc/hosts` on Linux/macOS and `C:\Windows\System32\drivers\etc\hosts` on Windows.

3. Configure Xdebug (Optional)

   Depending on your operating system, you can customize Xdebug behavior by editing either `/docker/dev/xdebug-main.ini` (Linux/Windows) or `/docker/dev/xdebug-osx.ini` (macOS).

    * To debug every request (Default):
      
      This is the default setting. It will intercept and debug all incoming API requests.
      ```ini
      xdebug.start_with_request = yes
      ```

    * To debug only specific requests (On-Demand):
      
      If you prefer to trigger the debugger manually only when making requests from a browser frontend, change the configuration to:
      ```ini
      xdebug.start_with_request = no
      ```
      
      Tip: Install the "Xdebug helper" extension for Chrome or Firefox and set the IDE Key to `PHPSTORM` in the extension settings.

4. Build and Initialize the Environment

   Run the following commands in your terminal to build the Docker images, start the containers, install PHP dependencies:
   ```bash
   make build
   make start
   make composer-install
   make env-dev
   ```
   Note 1: To change the default Docker configurations (such as WEB_PORT), open the `.env` file, update the required variables, then stop, rebuild, and restart the containers.

   Note 2: When modifying database variables in the `.env` file (like MYSQL_VERSION or MYSQL_ROOT_PASSWORD), ensure you stop the containers and delete the `storage/mysql-data` directory before rebuilding the images.

5. Apply Migrations and Seeds:
   ```bash
   make migrate
   make seed
   ```

6. Set key for application:
   ```bash
   make key-generate
   ```

7. Access Application Services

   Once the environment is successfully running, you can access the various services in your browser using the following URLs:
   * **DEV page:** [http://localhost](http://localhost)
   * **Mailpit (Debug Email):** [http://localhost:8025](http://localhost:8025)

## Setting up the STAGING environment locally
Important: This section describes how to set up the staging environment locally for debugging and verification purposes only. A real STAGING environment must be deployed on a dedicated server and should be as close to the PRODUCTION environment as possible.

Note 1: These steps assume you have already completed steps 1 through 2 of the "Setting up the DEV environment" section above.

Note 2: If you want to change default docker configurations (web_port, etc...) - create uncommitted `.env` file, copy data from `.env.staging`, edit necessary environment variables values.

1. Database Clean-up
   
   Delete the `storage/mysql-data` and `vendor` folder if it exists before starting.

2. Build and Initialize the Environment

   Run the following commands in your terminal to build the staging Docker images, start the containers, install PHP dependencies:
   ```bash
   make build-staging
   make start-staging
   ```
   Note: With `opcache.validate_timestamps=0` ([php.ini](docker/staging/php.ini)) enabled for performance, any manual file changes or code updates require a PHP-FPM restart/reload to take effect.

3. Apply Migrations:
   ```bash
   make migrate-no-test
   ```

4. Set key for application:
   ```bash
   make key-generate
   ```

## Setting up the PROD environment locally
Important: This section describes how to set up the production environment locally for debugging and verification purposes only. A real PROD environment must be deployed on a dedicated server.

Note 1: These steps assume you have already completed steps 1 through 2 of the "Setting up the DEV environment" section above.

Note 2: If you want to change default docker configurations (web_port, etc...) - create uncommitted `.env` file, copy data from `.env.prod`, edit necessary environment variables values.

1. Database Clean-up

   Delete the `storage/mysql-data` and `vendor` folder if it exists before starting.

2. Build and Initialize the Environment

   Run the following commands in your terminal to build the production Docker images, start the containers, install PHP dependencies:
   ```bash
   make build-prod
   make start-prod
   ```
   Note: With `opcache.validate_timestamps=0` ([php.ini](docker/prod/php.ini)) enabled for performance, any manual file changes or code updates require a PHP-FPM restart/reload to take effect.

3. Apply Migrations:
   ```bash
   make migrate-no-test
   ```

4. Set key for application:
   ```bash
   make key-generate
   ```

## Accessing Container Shells
Once the application is running (via `make start`), you can easily access the command line inside your containers.

To open a shell inside the main **laravel** container, run:
```bash
make ssh
```

You can also access the other services using the following commands:
```bash
make ssh-nginx
make ssh-supervisord
make ssh-mysql
```

Tip: Type `exit` and press Enter to leave the container's shell and return to your local terminal.

## Rebuilding Containers
If you modify any `Dockerfile` or environment configurations, you will need to rebuild the containers using the following commands:
```bash
make down
make build
make start
```

Note: Use environment-specific commands if you need to rebuild the test, staging, or production environments. For a complete list of available commands, run `make help`.

## Starting and Stopping Containers
Use the following commands to start or stop the development environment:
```bash
make start
make stop
```

If you are working with the staging or production environments, use their respective commands:
* Staging: `make start-staging` or `make stop-staging`.
* Production: `make start-prod` or `make stop-prod`.

## Stopping and Removing Containers
To completely stop and remove all environment containers and networks, use the following command:
```bash
make down
```

Note: Use environment-specific commands if you need to tear down the test, staging, or production environments. For a complete list of available commands, run `make help`.

## Available Makefile Commands
Here is a reference list of the primary commands available for managing the environment, databases, logs and testing:
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
make fish
make ssh-nginx
make ssh-supervisord
make ssh-mysql

make composer-install-no-dev
make composer-install
make composer-update
make composer-audit

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
make phpcpd-html-report
make phpmd
make phpstan
make phpinsights

# ... and many more
```
Note: For a complete list of all available commands, please inspect the `Makefile` directly or run `make help`.

## Architecture & packages
* [Laravel](https://laravel.com)
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
* [phpcpd](https://packagist.org/packages/systemsdk/phpcpd)
* [phpmd](https://packagist.org/packages/phpmd/phpmd)
* [phpstan](https://packagist.org/packages/nunomaduro/larastan)
* [phpinsights](https://packagist.org/packages/nunomaduro/phpinsights)
* [rector](https://packagist.org/packages/rector/rector)

## Guidelines
* [Commands](docs/commands.md)
* [Development](docs/development.md)
* [IDE PhpStorm Configuration](docs/phpstorm.md)
* [Xdebug Configuration](docs/xdebug.md)
* [Code Quality Tools](docs/code-quality.md)
* [Testing](docs/testing.md)

## Development Workflow
1. **Branching:** Create a new branch from `develop` using one of the following patterns:
    * `feature/{ticketNo}`
    * `bugfix/{ticketNo}`
2. **Commits:** Commit frequently and write clear, descriptive commit messages to facilitate the review process.
3. **Pull Request:** Push your branch to the repository and open a Pull Request (PR) against the `develop` branch. Use the following naming convention for your PR: `feature/{ticketNo} - Short descriptive title of the Jira task`.
4. **Review:** Address any feedback from reviewers and iterate as needed.
5. **CI/CD Checks:** Ensure that all continuous integration checks (e.g., CircleCI) pass successfully and the build status is green.
6. **Merge:** Once approved, your PR will be squashed and merged into `develop`. It will later be merged into a `release/{version}` branch for deployment.

Note: For a detailed visual guide on this branching model, please refer to the [Git Flow Cheatsheet](https://danielkummer.github.io/git-flow-cheatsheet).

## License
[The MIT License (MIT)](LICENSE)
