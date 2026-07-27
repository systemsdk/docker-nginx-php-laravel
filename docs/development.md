# Development Guidelines
This document outlines the fundamental principles, coding standards and best practices for developing within this project.

## General
* Follow the [PSR-1](https://www.php-fig.org/psr/psr-1/), [PSR-12](https://www.php-fig.org/psr/psr-12/) standards.
* Keep class names descriptive, informative and concise.
* Adhere strictly to Laravel conventions and best practices.
* Maintain a clear separation of concerns by isolating application logic from the presentation and data-persistence layers.
* Use namespaces logically to group related classes into coherent directories.
* Leverage caching for expensive operations, provided that the cache invalidation strategy is straightforward and reliable.
* Use queue workers to delegate when you don't need to wait for data to return.
* Document all custom architectural decisions, complex logic and functionality that falls outside of standard MVC patterns.
* Write application, integration and unit tests for all new features (prioritizing in that exact order).
* Design all functionality to be easily mockable. This ensures every part of the application can be tested in isolation without relying on third-party dependencies.
* Enforce strict typing (`declare(strict_types=1);`) and consistently use both parameter and return type hints.
* We highly recommend using **PhpStorm** as your primary IDE, as it provides the most robust toolset for modern PHP development.

#### Controllers
Keep controllers clean of application logic. They should ideally just inject repositories - either through the constructor (if used more than once) or in the controller method itself.

#### Events
Events for models are handled by event listeners. These should be queueable (implement ShouldQueue) and called explicitly with `event()`.

#### Resources
Use Resources to transform model data into JSON.

#### Services
Isolate 3rd party dependencies into Service classes for simple refactoring/extension.

#### Repositories
Most application logic in controllers should be wrapped in repository functions. Never lazyload more than you need.

#### Models
Models should only be data-persistence layers, i.e. defines relationships, attributes, helper methods but does not fetch collections of data.

#### Exceptions
* All Exceptions that should terminate the current request (and return an error message to the user) should be handled by `App\Exceptions\Handler`.
* All Exceptions that should be handled in the controller, or just logged for debugging, should be wrapped in a try catch block (catchable Exceptions).
* Use custom Exceptions for all catchable scenarios, and try to use standard Illuminate Exceptions (like AuthenticationException) for fatal Exceptions.
* Use custom Exceptions to log.

## IDE
Short list of most popular IDE for PHP development:

* [PhpStorm](https://www.jetbrains.com/phpstorm/)
* [Eclipse PDT](https://www.eclipse.org/pdt/)
* [NetBeans](https://netbeans.org/)
* [Sublime Text](https://www.sublimetext.com/)
