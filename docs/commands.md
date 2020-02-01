# Commands
This document describing commands that can be used in local shell or inside laravel container shell.

## Local shell (Makefile)
This environment comes with "Makefile" and it allow to simplify using some functionality.
In order to use command listed bellow just use next syntax in your local shell: `make {command name}`.
Next commands available for this environment:
```bash
make start                  # Start dev environment
make start-test             # Start test or continuous integration environment
make start-prod             # Start prod environment

make stop                   # Stop dev environment
make stop-test              # Stop test or continuous integration environment
make stop-prod              # Stop prod environment

make restart                # Stop and start dev environment
make restart-test           # Stop and start test or continuous integration environment
make restart-prod           # Stop and start prod environment

make env-dev                # Create config for dev environment
make env-test-ci            # Create config for test/ci environment

make ssh                    # Enter laravel container shell
make ssh-nginx              # Enter nginx container shell
make ssh-supervisord        # Enter supervisord container shell (cron jobs running there, etc...)
make ssh-mysql              # Enter mysql container shell

make exec                   # Exucute some command defined in cmd="..." variable inside laravel container shell
make exec-bash              # Execute several commands defined in cmd="..." variable inside laravel container shell

make report-prepare         # Create /reports/coverage folder, will be used for report after running tests
make report-clean           # Delete all reports in /reports/ folder

make wait-for-db            # Checking MySQL database availability, currently using for CircleCI (see /.circleci folder)

make composer-install-prod  # Installing composer dependencies for prod environment (without dev tools)
make composer-install       # Installing composer dependencies for dev environment
make composer-update        # Update composer dependencies

make info                   # Display information about laravel version and php version

make logs                   # Display logs for laravel container. Use ctrl+c in order to exit
make logs-nginx             # Display logs for nginx container. Use ctrl+c in order to exit
make logs-supervisord       # Display logs for supervisord container. Use ctrl+c in order to exit
make logs-mysql             # Display logs for mysql container. Use ctrl+c in order to exit

make drop-migrate           # Drop databases (main and for tests) and run all migrations
make migrate                # Run all migrations for databases (main and for tests)
make migrate-prod           # Run all migrations for main database

make seed                   # Run all seeds for test database

make phpunit                # Run all tests
make report-code-coverage   # Update code coverage report on https://coveralls.io (COVERALLS_REPO_TOKEN should be set on CI side)

make phpcs                  # Run PHP CodeSniffer
make ecs                    # Run The Easiest Way to Use Any Coding Standard
make ecs-fix                # Run The Easiest Way to Use Any Coding Standard to fix issues
phpmetrics                  # Generates PhpMetrics static analysis
```

## Laravel container shell
Inside laravel container shell available "native" laravel commands with their description and, in additional, custom commands.
In order to enter inside laravel container shell please use next command on your local shell:
```bash
make ssh
```
After above command you will be inside laravel container and for display list of available commands please use next command:
```bash
php artisan
```
