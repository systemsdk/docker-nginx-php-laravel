# Testing
This document describing how you can run tests.

### General
This environment contains the next types of tests:

* Application tests (TODO: Implement it)
* Unit tests (TODO: Implement it)

All tests relies to [PHPUnit](https://phpunit.de/) library.

Note: `Application` test === `Feature` test === `Functional` test, please use symfony's naming convention(`Application`) as described [here](https://symfony.com/doc/current/testing.html#application-tests).

### Commands to run tests
You can run tests using the following local shell command(s):
```bash
make phpunit    # Run all tests
```

After execution above local shell command, you are able to check a code coverage report. Please open `reports/coverage/index.html` with your browser.

If you want to run a single test or all tests in specified directory, you can use the next steps:

1.Use next local shell command in order to enter into laravel container shell:
```bash
make ssh    # Enter laravel container shell
```
2.Use next laravel container shell command(s) in order to run test(s):
```bash
./vendor/bin/phpunit ./tests/Application/Controller/ApiKeyControllerTest.php  # Just this single test class
./vendor/bin/phpunit ./tests/Application/Controller/                          # All tests in the directory
```

### Separate environment for testing
By default, this environment is using a separate database for testing.
If you need to change separate environment for testing (f.e. change database or another stuff) you need to edit `.env.test` file.

## PhpStorm
You can run tests directly from your IDE PhpStorm. Please follow [PhpStorm](phpstorm.md) documentation in order to do it.
