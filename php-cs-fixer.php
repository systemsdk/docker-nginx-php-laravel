<?php

declare(strict_types=1);

# Temporary solution for PhpStorm quality tools as php-cs-fixer is not supporting php 8.2 currently
putenv('PHP_CS_FIXER_IGNORE_ENV=1');
include __DIR__ . '/vendor/bin/php-cs-fixer';
