# Commands
This document describes the primary commands available in your local terminal to interact with the environment and the internal Laravel container.

## Local Shell (Makefile)
This environment includes a `Makefile` designed to simplify common tasks and workflows. To execute any of the commands listed below, use the following syntax in your local terminal: `make {command_name}`.

Here is the complete list of available commands:
```bash
make help                     # Show available commands and their descriptions

make build                    # Build the development environment
make build-test               # Build the test or CI environment
make build-staging            # Build the staging environment
make build-prod               # Build the production environment

make start                    # Start the development environment
make start-test               # Start the test or CI environment
make start-staging            # Start the staging environment
make start-prod               # Start the production environment

make stop                     # Stop the development environment containers (without removing them)
make stop-test                # Stop the test or CI environment containers (without removing them)
make stop-staging             # Stop the staging environment containers (without removing them)
make stop-prod                # Stop the production environment containers (without removing them)

make down                     # Stop and remove the development environment containers and networks
make down-test                # Stop and remove the test or CI environment containers and networks
make down-staging             # Stop and remove the staging environment containers and networks
make down-prod                # Stop and remove the production environment containers and networks

make restart                  # Restart the development environment
make restart-test             # Restart the test or CI environment
make restart-staging          # Restart the staging environment
make restart-prod             # Restart the production environment

make env-dev                  # Create config for dev environment
make env-test-ci              # Create config for test/ci environment

make ssh                      # Access the bash shell inside the laravel container
make ssh-root                 # Access the bash shell as root inside the laravel container
make fish                     # Access the fish shell inside the laravel container (https://www.youtube.com/watch?v=C2a7jJTh3kU)
make ssh-nginx                # Access the bash shell inside the nginx container
make ssh-supervisord          # Access the bash shell inside the supervisord container (cron jobs, etc.)
make ssh-mysql                # Access the bash shell inside the mysql container

make exec                     # Execute a command (defined in cmd="...") as www-data user inside the laravel container
make exec-bash                # Execute multiple commands (defined in cmd="...") as www-data user inside the laravel container
make exec-by-root             # Execute a command (defined in cmd="...") as root user inside the laravel container

make report-prepare           # Create the /reports/coverage folder (used for test reports)
make report-clean             # Remove all generated reports in the /reports/ folder

make wait-for-db              # Check MySQL database availability (useful for CI/CD, e.g. /.circleci)

make composer-install-no-dev  # Install Composer dependencies (excluding dev packages)
make composer-install         # Install all Composer dependencies
make composer-update          # Update Composer dependencies
make composer-audit           # Check installed packages for security vulnerabilities

make key-generate             # Set the application key

make info                     # Show the current PHP and Laravel versions

make logs                     # View logs from the laravel container (use ctrl+c to exit)
make logs-nginx               # View logs from the nginx container (use ctrl+c to exit)
make logs-supervisord         # View logs from the supervisord container (use ctrl+c to exit)
make logs-mysql               # View logs from the mysql container (use ctrl+c to exit)

make drop-migrate             # Drop databases and run all migrations for main/test databases
make migrate                  # Run all migrations for main/test databases
make migrate-no-test          # Run all migrations for the main database only

make seed                     # Run all seeds for the test database

make phpunit                  # Run the PHPUnit test suite
make report-code-coverage     # Update code coverage report on Coveralls.io (requires COVERALLS_REPO_TOKEN, should be set on CI side)

make ecs                      # Run Easy Coding Standard (ECS) checks
make ecs-fix                  # Run Easy Coding Standard to automatically fix issues
make phpcs                    # Run PHP CodeSniffer checks
make phpmetrics               # Generate a PhpMetrics static analysis report
make phpcpd                   # Run PHP Copy/Paste Detector
make phpcpd-html-report       # Generate an HTML report for PHP Copy/Paste Detector
make phpmd                    # Run PHP Mess Detector
make phpstan                  # Run PHPStan static analysis
make phpinsights              # Run PHP Insights analysis

make composer-normalize       # Normalize the composer.json file structure
make composer-validate        # Validate the composer.json file syntax
make composer-require-checker # Check defined dependencies against actual code usage
make composer-unused          # Detect unused Composer packages by scanning namespaces
```

## Laravel Container Shell
Inside the Laravel container, you have access to both native Laravel commands and custom application commands.

To access the Laravel container shell, run the following command in your local terminal:
```bash
make ssh
```
Once inside the container, you can display the full list of available commands by running:
```bash
php artisan
```
