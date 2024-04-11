# Development
This document contains basic information and recommendation for development.

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
* Use PHPStorm IDE as currently it is most powerful IDE for PHP development on today's market.

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


## PHP code quality
You can control code quality of your PHP project using already integrated code quality tools. Before creating merge request you can run on your local PC code quality tools and get the report with issues that you can fix.
Also code quality tools integrated inside CI environment and after creating merge request you can check if you have some issues inside your code. Please find the list of code quality tools that we recommend to use while PHP backend development.

### PHP coding standard
This tool is an essential development tool that ensures your code remains coding standard.

PHP coding standard is available for dev/test environment using next local shell command:
```bash
make ecs
```

If you want to fix all possible issues in auto mode(some issues can be fixed only manually) just use next local shell command:
```bash
make ecs-fix
```

### PHP code sniffer
This tool is an essential development tool that ensures your code remains clean and consistent.

PHP Code Sniffer is available for dev/test environment using next local shell command:
```bash
make phpcs
```

If you are using [PhpStorm](https://www.jetbrains.com/phpstorm/) you can configure PHP Code Sniffer using recommendation
[here](https://www.jetbrains.com/help/phpstorm/using-php-code-sniffer.html).

### PHPStan static analysis tool
PHPStan focuses on finding errors in your code without actually running it. It catches whole classes of bugs even before you write tests for the code.
It moves PHP closer to compiled languages in the sense that the correctness of each line of the code can be checked before you run the actual line.

PHPStan static analysis tool is available for dev/test environment using next local shell command:
```bash
make phpstan
```

### Phpinsights PHP quality checks
PHP Insights was carefully crafted to simplify the analysis of your code directly from your terminal, and is the perfect starting point to analyze the code quality of your PHP projects.

Phpinsights is available for dev/test environment using next local shell command:
```bash
make phpinsights
```

### PHP mess detector
This tool takes a given PHP source code base and look for several potential problems within that source. These problems can be things like:
* Possible bugs
* Suboptimal code
* Overcomplicated expressions
* Unused parameters, methods, properties

PHP mess detector is available for dev/test environment using next local shell command:
```bash
make phpmd
```

### PHP copy/paste detector
This tool is a copy/paste detector for PHP code.

PHP copy/paste detector is available for dev/test environment using next local shell command:
```bash
make phpcpd
```

### Composer tools
To normalize or validate your composer.json you can use next local shell commands:
```bash
make composer-normalize
make composer-validate
```

If you need to find unused packages by scanning your code you can use next local shell commands:
```bash
make composer-unused
```

In order to check the defined dependencies against your code you can use next local shell commands:
```bash
make composer-require-checker
```

### Metrics
This environment contains [PhpMetrics](https://github.com/phpmetrics/phpmetrics) to make some code analysis.
Use next local shell command in order to run it:
```bash
make phpmetrics
```
Note: You need run tests before this local shell command.

After execution above local shell command please open `reports/phpmetrics/index.html` with your browser.

### Rector
Rector instantly upgrades and refactors the PHP code of your application. It can help you in 2 major areas:
- Instant upgrades
- Automated refactoring

Rector now supports upgrades of your code from PHP 5.3 to 8.2 or upgrades your code for new framework version. This tool supports major open-source projects like Symfony, PHPUnit, Nette, Laravel, CakePHP and Doctrine.
You can find live demo [here](https://symfonycasts.com/screencast/symfony6-upgrade/rector) or more info [here](https://packagist.org/packages/rector/rector).

Rector is available for test/dev environment. If you need to run this tool, please use next local shell command in order to enter inside laravel container shell and then run rector:
```bash
make ssh
```
```bash
vendor/bin/rector process app/your_folder_with_code_for_refactoring
```
Note: You can process rector without specifying folder, in such case it will process app and tests folder.

### Qodana (trial)
Qodana is a smart code quality platform by JetBrains. This powerful static analysis engine enables development teams to automate code reviews, build quality gates, and enforce code quality guidelines enterprise-wide – all within their JetBrains ecosystems.
The platform can be integrated into any CI/CD pipeline and can analyze code (currently there are some issues with CI - https://youtrack.jetbrains.com/issue/QD-7379).

If you are using IDE PHPStorm, you can use it via menu `Tools` -> `Qodana` -> `Try Code Analysis with Qodana` -> `Try Locally` -> `Run`.
You can find some video [here](https://blog.jetbrains.com/qodana/2023/09/code-quality-under-pressure-supporting-developers-with-qodana-integration-in-intellij-based-ides/) or more info [here](https://www.jetbrains.com/help/qodana/getting-started.html).

## IDE
Short list of most popular IDE for PHP development:

* [PhpStorm](https://www.jetbrains.com/phpstorm/)
* [Zend Studio](https://www.zend.com/products/zend-studio)
* [Eclipse PDT](https://www.eclipse.org/pdt/)
* [NetBeans](https://netbeans.org/)
* [Sublime Text](https://www.sublimetext.com/)
