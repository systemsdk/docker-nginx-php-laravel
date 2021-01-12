# Development
This document contains basic information and recommendation for development this application.

## General
* Follow the [PSR-1 guide](https://www.php-fig.org/psr/psr-1/), [PSR-12 guide](https://www.php-fig.org/psr/psr-12/).
* Try to keep class names informative but not too long.
* Follow Laravel conventions and good practices.
* Separate application logic from presentation and data-persistence layers.
* Use namespaces to group all related classes into separate folders.
* Put stuff in the cache when its easy enough to invalidate.
* Use queue workers to delegate when you don't need to wait for data to return.
* Write documentation for all things outside of standard MVC functions.
* Write integration and unit tests for all new features (in that order of priority).
* All functionality needs to be "mockable", so that you can test every part of the app without 3rd party dependencies.
* Use strict_types, type hinting and return type hinting.

#### Exceptions
* All Exceptions that should terminate the current request (and return an error message to the user) should be handled
by `App\Exceptions\Handler`.
* All Exceptions that should be handled in the controller, or just logged for debugging, should be wrapped in a
try catch block (catchable Exceptions).
* Use custom Exceptions for all catchable scenarios, and try to use standard Illuminate Exceptions
(like AuthenticationException) for fatal Exceptions.
* Use custom Exceptions to log.

#### Models
Models should only be data-persistence layers, i.e. defines relationships, attributes, helper methods
but does not fetch collections of data.

#### Repositories
Most application logic in controllers should be wrapped in repository functions.
Never lazyload more than you need.

#### Events
Events for models are handled by event listeners. These should be queueable (implement ShouldQueue)
and called explicitly with `event()`.

#### Controllers
Keep controllers clean of application logic. They should ideally just inject repositories - either through
the constructor (if used more than once) or in the controller method itself.

#### Resources
Use Resources to transform model data into JSON.

#### Services
Isolate 3rd party dependencies into Service classes for simple refactoring/extension.


## IDE
Short list of most popular IDE for PHP development:

* [PhpStorm](https://www.jetbrains.com/phpstorm/)
* [Zend Studio](https://www.zend.com/products/zend-studio)
* [Eclipse PDT](https://www.eclipse.org/pdt/)
* [NetBeans](https://netbeans.org/)
* [Sublime Text](https://www.sublimetext.com/)


## PHP coding standard
This tool is an essential development tool that ensures your code remains coding standard.

PHP coding standard is available for dev/test environment using next local shell command:
```bash
make ecs
```

If you want to fix all possible issues in auto mode(some issues can be fixed only manually) just use next local shell command:
```bash
make ecs-fix
```

## PHP code sniffer
This tool is an essential development tool that ensures your code remains clean and consistent.

PHP Code Sniffer is available for dev/test environment using next local shell command:
```bash
make phpcs
```

If you are using [PhpStorm](https://www.jetbrains.com/phpstorm/) you can configure PHP Code Sniffer using recommendation
[here](https://www.jetbrains.com/help/phpstorm/using-php-code-sniffer.html).

## PHP copy/paste detector
This tool is a copy/paste detector for PHP code.

PHP copy/paste detector is available for dev/test environment using next local shell command:
```bash
make phpcpd
```

## PHP mess detector
This tool takes a given PHP source code base and look for several potential problems within that source. These problems can be things like:
* Possible bugs
* Suboptimal code
* Overcomplicated expressions
* Unused parameters, methods, properties

PHP mess detector is available for dev/test environment using next local shell command:
```bash
make phpmd
```

## PHPStan static analysis tool
PHPStan focuses on finding errors in your code without actually running it. It catches whole classes of bugs even before you write tests for the code.
It moves PHP closer to compiled languages in the sense that the correctness of each line of the code can be checked before you run the actual line.

PHPStan static analysis tool is available for dev/test environment using next local shell command:
```bash
make phpstan
```

## Phpinsights PHP quality checks
PHP Insights was carefully crafted to simplify the analysis of your code directly from your terminal, and is the perfect starting point to analyze the code quality of your PHP projects. 

Phpinsights is available for dev/test environment using next local shell command:
```bash
make phpinsights
```
