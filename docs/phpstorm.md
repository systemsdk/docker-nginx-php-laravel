# JetBrains PhpStorm Configuration
This document describes the recommended IDE settings, plugins, and integrations for [JetBrains PhpStorm](https://www.jetbrains.com/phpstorm/) to ensure a consistent development experience across the team.

## General Settings

### Recommended Plugins
To enhance productivity and code quality, navigate to `Settings` -> `Plugins` and install the following plugins:
* `.ignore`: Advanced support for `.gitignore` and `.dockerignore` files.
* `Php Inspections (EA Ultimate)`: A powerful static code analyzer for PHP (Paid plugin) or free plugin `Php Inspections (EA Extended)`.
* `JetBrains AI Assistant`: AI-powered coding assistance.
* `Laravel Idea`: Laravel framework support plugin.
* `Laravel Query`: Provides database integration for Laravel query builder.
* `Laravel Tinker`: Easily write and execute PHP code directly in PhpStorm/IDEA as if using laravel artisan tinker.
* `Rainbow Brackets`: Simplifies reading complex nested code.
* `String Manipulation`: Powerful text manipulation tools.

### Laravel Integration
To enable framework-specific autocompletion and features:
* Go to `Settings` -> `PHP` -> `Frameworks` -> `Laravel Idea` and check settings for `Laravel Idea` plugin.

> 💡 Code Quality Tools: If you are setting up PhpStorm to automatically run code inspections, please refer to the tools and configurations described in [code-quality.md](code-quality.md).

## CLI Interpreter (Docker Integration)
To ensure PhpStorm correctly analyzes code, runs PHPUnit tests, and executes linters, you must set up a remote CLI interpreter that points to our Docker environment.

To configure this, navigate to `Settings` -> `PHP` and follow the official JetBrains guide for [Configuring Remote PHP Interpreters](https://www.jetbrains.com/help/phpstorm/configuring-remote-interpreters.html).

![CLI Interpreter 1](images/phpstorm_00.png)
![CLI Interpreter 2](images/phpstorm_01.png)

## Composer
Navigate to `Settings` -> `PHP` -> `Composer` and set the path to your `composer.json` file. Verify that the rest of the settings match the example below:

![Composer Settings](images/phpstorm_02.png)

## Server Path Mappings
To ensure step debugging and remote execution work correctly, you must map your local files to the Docker container. Navigate to `Settings` -> `PHP` -> `Servers` and configure the absolute paths:

![Server Path Mappings](images/phpstorm_03.png)

## Test Frameworks (PHPUnit)
To run and debug tests directly from the IDE, set up the remote PHPUnit integration in `Settings` -> `PHP` -> `Test Frameworks`:

![Test Frameworks Configuration](images/phpstorm_04.png)

Next, create a Run/Debug Configuration for `PHP Remote Debug` matching the parameters below:

![Remote Debug Configuration](images/phpstorm_05.png)

## Debugging (Xdebug)
For detailed instructions on setting up and using Xdebug in this environment, please refer to our dedicated [Xdebug Documentation](xdebug.md).

## Code Style & Shared Settings
Our project repository includes the `.idea/` directory, meaning most code style and inspection configurations are available out of the box.

> Note: If you prefer to manage your own IDE settings, you can add `.idea/` to your local `.gitignore` and delete the folder from your git repository.

If you are starting fresh or do not have the committed `.idea/` folder, you can import our recommended code style manually:
1. Go to `Settings` -> `Editor` -> `Code Style` -> `PHP`.
2. Import the `Project` scheme (`CodeStyle.xml`) located in the [docs/phpstorm](phpstorm) directory.

![Code Style Import](images/phpstorm_code_style.png)

## Quality Tools Integration
PhpStorm can automatically highlight code violations caught by linters (PHP Code Sniffer, PHPStan, Mess Detector).

### Enabling Quality Tools
Go to `Settings` -> `PHP` -> `Quality Tools` and configure the paths to the tools inside the Docker container.

![Quality Tools Overview](images/phpstorm_06.png)

#### PHP_CodeSniffer
![PHPCS Config 1](images/phpstorm_php_code_sniffer_1.png)
![PHPCS Config 2](images/phpstorm_php_code_sniffer_2.png)

#### PHP CS Fixer
Ensure you select the proper local path for the ruleset `.php-cs-fixer.dist.php`.

![CS Fixer Config 1](images/phpstorm_php_cs_fixer_1.png)
![CS Fixer Config 2](images/phpstorm_php_cs_fixer_2.png)

#### Laravel Pint
![Path mappings](images/phpstorm_laravel_pint_1.png)
![Path mappings](images/phpstorm_laravel_pint_2.png)

#### PHPStan
![PHPStan Config 1](images/phpstorm_phpstan_1.png)
![PHPStan Config 2](images/phpstorm_phpstan_2.png)

#### Mess Detector
Ensure you select the proper local path for the ruleset `phpmd_ruleset.xml`.

![PHPMD Config 1](images/phpstorm_phpmd_1.png)
![PHPMD Config 2](images/phpstorm_phpmd_2.png)

### Importing the Inspections Profile
If you are not using the committed `.idea/` folder, you must import our custom inspections profile:
* Go to `Settings` -> `Editor` -> `Inspections` and import the `Project Default` profile (`Inspections.xml`) from the [docs/phpstorm](phpstorm) directory.

![Inspections Import](images/phpstorm_inspections.png)

### External Tools (Manual Execution via IDE)
For convenience, you can add custom right-click context menu actions to run linters on specific files or folders. Go to `Settings` -> `Tools` -> `External Tools` and create the following tools:

#### Tool 1: ECS (Easy Coding Standard)
* Arguments: `exec-bash cmd="./vendor/bin/ecs --clear-cache check $FilePathRelativeToProjectRoot$"`

![ECS External Tool](images/phpstorm_12.png)

#### Tool 2: PHPCS (CodeSniffer)
* Arguments: `exec-bash cmd="./vendor/bin/phpcs --version && ./vendor/bin/phpcs --standard=PSR12 --colors -p $FilePathRelativeToProjectRoot$"`

![PHPCS External Tool](images/phpstorm_13.png)

> 💡 Usage: Right-click any file or folder in the project tree, navigate to `External Tools`, and select `ecs` or `phpcs`.

---

**Running Full Project Inspections:** To run a full project analysis utilizing all configured quality tools, use the IDE's main menu: `Code` -> `Inspect Code`.

## External Documentation & References
For deeper customization and troubleshooting, please refer to the official documentation and plugin pages:

* [Configuring Remote PHP Interpreters](https://www.jetbrains.com/help/phpstorm/configuring-remote-interpreters.html)
* [PHP Test Frameworks in PhpStorm](https://www.jetbrains.com/help/phpstorm/php-test-frameworks.html)
* [Laravel Development using PhpStorm](https://blog.jetbrains.com/phpstorm/2015/01/laravel-development-using-phpstorm/)
* [Laravel Plugin plugin for PhpStorm](https://plugins.jetbrains.com/plugin/7532-laravel)
* [Php Inspections (EA Extended) Plugin](https://plugins.jetbrains.com/plugin/7622-php-inspections-ea-extended-)
* [Qodana code quality tool](https://blog.jetbrains.com/qodana/2023/09/code-quality-under-pressure-supporting-developers-with-qodana-integration-in-intellij-based-ides/)
