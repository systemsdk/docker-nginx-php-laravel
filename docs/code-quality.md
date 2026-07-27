# Code Quality Standards

This document outlines the automated code quality tools and practices utilized within this project to maintain a clean, secure and robust codebase.

## PHP Code Quality
To ensure our architectural rules and coding standards are strictly followed, we rely on a pre-configured suite of static analysis and formatting tools.

* **Local Verification:** Before submitting a Merge/Pull Request, you must run these tools on your local machine to identify and resolve any violations.
* **Continuous Integration (CI):** These identical tools are integrated directly into our CI pipeline. Any Merge Request failing these automated checks will be blocked from merging.

Below is the configured stack of tools used for PHP backend development in this project.

### Easy Coding Standard (ECS)
[Easy Coding Standard](https://packagist.org/packages/symplify/easy-coding-standard) is an essential tool that ensures your code strictly adheres to the project's defined formatting rules (PSR-12 and Laravel conventions).

ECS is available for the dev/test environment using the following command in your local shell:
```bash
make ecs
```

ECS can automatically fix most formatting issues (e.g., indentation, line endings, array syntax). To apply these automatic fixes, run the following in your local shell:
```bash
make ecs-fix
```

Note: While the auto-fixer handles the majority of formatting errors, some complex violations may require manual intervention. Always review the changes made by the auto-fixer before committing your code.

### PHP Code Sniffer
[PHP_CodeSniffer](https://packagist.org/packages/squizlabs/php_codesniffer) is a vital tool used to detect violations of our defined coding standards, ensuring the codebase remains clean and structurally consistent.

PHP_CodeSniffer is available for the dev/test environment using the following command in your local shell:
```bash
make phpcs
```

Note: If you are using PhpStorm, we highly recommend integrating PHP_CodeSniffer directly into your environment for real-time feedback. You can find the setup instructions specific to our project in [phpstorm.md](phpstorm.md) or refer to the [official JetBrains documentation](https://www.jetbrains.com/help/phpstorm/using-php-code-sniffer.html).

### PHPStan Static Analysis Tool
[PHPStan](https://packagist.org/packages/larastan/larastan) is a powerful static analysis tool that focuses on finding errors in your code without actually running it. It catches whole classes of bugs even before you write tests, bringing PHP closer to compiled languages by verifying the correctness of your code prior to execution.

PHPStan is available for the dev/test environment. To run the analysis, execute the following command in your local shell:
```bash
make phpstan
```

Note: PhpStorm provides native support for PHPStan. We highly recommend enabling it to spot typing errors, undefined methods and logical bugs directly while typing. For specific configuration details, please refer to [phpstorm.md](phpstorm.md) or the [official JetBrains documentation](https://www.jetbrains.com/help/phpstorm/using-phpstan.html).

### PHP Insights
[PHP Insights](https://packagist.org/packages/nunomaduro/phpinsights) provides a comprehensive, high-level overview of our code quality directly in the terminal. It analyzes the codebase across four key metrics (Code, Complexity, Architecture and Style), making it an excellent tool for tracking overall project health and technical debt.

PHP Insights is available for the dev/test environment. To run the analysis and view the dashboard, execute the following command in your local shell:
```bash
make phpinsights
```

### PHP Mess Detector
[PHP Mess Detector](https://packagist.org/packages/phpmd/phpmd) (PHPMD) analyzes the codebase to identify potential structural problems, technical debt and anti-patterns. Specifically, it scans the code for:
* Possible bugs and empty catch blocks.
* Suboptimal or dead code (e.g., unused parameters, methods and properties).
* Overcomplicated expressions and high cyclomatic complexity.

PHPMD is available for the dev/test environment. To run the analysis, execute the following command in your local shell:
```bash
make phpmd
```

Note: PhpStorm provides native support for PHPMD. We recommend enabling it to highlight suboptimal code and unused variables directly in your editor. Configuration details can be found in [phpstorm.md](phpstorm.md) or the [official JetBrains documentation](https://www.jetbrains.com/help/phpstorm/using-php-mess-detector.html).

### PHP Copy/Paste Detector
[PHP Copy/Paste Detector](https://packagist.org/packages/systemsdk/phpcpd) (PHPCPD) scans the codebase to identify duplicated logic and redundant code blocks. It is an essential tool for enforcing the DRY (Don't Repeat Yourself) principle and highlighting areas that are prime candidates for refactoring.

PHPCPD is available for the dev/test environment. To run the analysis, execute the following commands in your local shell:
```bash
make phpcpd
```

Run the next command to generate a detailed HTML report for easier navigation:
```bash
make phpcpd-html-report
```

### Composer Tools
Maintaining a clean, accurate and optimized `composer.json` is crucial for project stability and architectural efficiency. We utilize a suite of tools to ensure our dependencies are strictly managed, preventing repository bloat and hidden dependency traps.

These tools are available for the dev/test environment. Execute the following commands in your local shell:

**Validation & Normalization**

To validate the syntax of your `composer.lock` and `composer.json` and to normalize its structure (standardizing formatting and sorting packages alphabetically), use:
```bash
make composer-validate
make composer-normalize
```

**Dependency Usage Analysis**

To scan the codebase and find explicitly required packages that are no longer used anywhere in your code (this keeps the application simple, lightweight and free of unnecessary external dependencies):
```bash
make composer-unused
```

**Strict Requirement Checking**

To detect "shadow dependencies" - packages that are used within your code but are not explicitly defined in your composer.json (meaning they were implicitly pulled in by another package):
```bash
make composer-require-checker
```

**Security & Abandoned Packages Audit**

To audit your dependencies for known security vulnerabilities (CVEs) and identify abandoned packages, use:
```bash
make composer-audit
```

### PhpMetrics
[PhpMetrics](https://packagist.org/packages/phpmetrics/phpmetrics) provides comprehensive static analysis and generates visual HTML reports detailing the maintainability, cyclomatic complexity and architectural health of the codebase.

PhpMetrics is available for the dev/test environment. Execute the following command in your local shell:
```bash
make phpmetrics
```

Important Prerequisite: You must run the test suite before executing this command. PhpMetrics relies on the generated test coverage data to accurately correlate code complexity with test coverage metrics.

**Viewing the Report**

Once the analysis is complete, you can view the interactive dashboard by opening the generated file in your web browser: `reports/phpmetrics/index.html`.

### Rector
[Rector](https://packagist.org/packages/rector/rector) is an advanced AST-based tool that instantly upgrades and refactors your PHP code. It is an invaluable asset for two major areas:
* Automated Refactoring: Enforcing clean code practices, modernizing legacy syntax and improving code quality.
* Instant Upgrades: Automatically adapting your codebase for new PHP versions (up to PHP 8.x) and major framework updates (supporting Symfony, Laravel, CakePHP, Doctrine, PHPUnit and more).

For a practical demonstration, check out this [SymfonyCasts demo](https://symfonycasts.com/screencast/symfony6-upgrade/rector), or visit its [Packagist page](https://packagist.org/packages/rector/rector) for more info.

Rector is available for the dev/test environment.

> ⚠️ Execution Context: Unlike the other static analysis tools, Rector must be executed inside the Laravel container.

First, access the container from your local shell:
```bash
make ssh
```

Once inside the container shell, execute Rector:
```bash
# Refactor a specific directory (highly recommended to review changes module by module)
vendor/bin/rector process src/Your/Specific/Folder

# Refactor the entire codebase (processes the 'src' and 'tests' directories by default)
vendor/bin/rector process
```

### Qodana (trial)
Qodana is a smart code quality platform by JetBrains. This powerful static analysis engine enables development teams to automate code reviews, build quality gates, and enforce code quality guidelines enterprise-wide – all within their JetBrains ecosystems.
The platform can be integrated into any CI/CD pipeline and can analyze code (currently there are some issues with CI - https://youtrack.jetbrains.com/issue/QD-7379).

If you are using IDE PHPStorm, you can use it via menu `Tools` -> `Qodana` -> `Try Code Analysis with Qodana` -> `Try Locally` -> `Run`.
You can find some video [here](https://blog.jetbrains.com/qodana/2023/09/code-quality-under-pressure-supporting-developers-with-qodana-integration-in-intellij-based-ides/) or more info [here](https://www.jetbrains.com/help/qodana/getting-started.html).
