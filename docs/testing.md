# Testing
This document describes how to run and configure tests for this project.

## Overview
This environment uses [PHPUnit](https://phpunit.de/) and includes the following types of tests:

* Application tests (TODO: Implement it)
* Integration tests (TODO: Implement it)
* Unit tests (TODO: Implement it)

To learn about our practical strategy for applying these tests efficiently in real-world projects, watch our video guide on YouTube: [Robust Testing](https://www.youtube.com/@systemsdk).

Note on naming: In Laravel's terminology, `Feature` tests are the same as `Application` tests. We follow the official Symfony naming convention as described [here](https://symfony.com/doc/current/testing.html#application-tests).

## 🚀 How to Run Tests
There are two main ways to run tests: using a single make command (recommended) or running them manually inside the Docker container (for advanced use/debugging).

### 1. Run All Tests (Recommended)

This is the simplest way to run the entire test suite and generate a code coverage report.
From your local shell, run:
```bash
make phpunit
```

After the command finishes, you can open the code coverage report in your browser. The report is generated at: `reports/coverage/index.html`.

### 2. Run Specific Tests (Advanced):

If you need to run a single test file, a specific directory, or a test suite (e.g., only "Unit" tests), you must do so from within the container's shell.

Step 1. Enter the Laravel container shell:
```bash
make ssh
```

Step 2. Run PHPUnit manually:

Once inside the container, you can execute phpunit directly.

* To run a single test class:
```bash
./vendor/bin/phpunit ./tests/Application/ApiKey/Transport/Controller/Api/V1/ApiKeyControllerTest.php
```

* To run all tests in a directory:

```bash
./vendor/bin/phpunit ./tests/Application/ApiKey/Transport/Controller/Api/V2/
```

* To run a specific test suite (e.g., Unit, as defined in phpunit.xml.dist):
```bash
./vendor/bin/phpunit --testsuite Unit
```

## ⚙️ Test Environment Configuration
By default, tests run in an isolated environment using a separate database.

This environment is configured in the `.env.test` file. If you need to change the test database connection or other service settings for the test environment, you should edit this file.

## 💡 IDE Integration & Notes
### PhpStorm
You can run and debug tests directly from your IDE.

Please follow [PhpStorm Setup Guide](phpstorm.md) documentation to configure it.
