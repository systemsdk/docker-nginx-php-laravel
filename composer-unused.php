<?php

declare(strict_types=1);

use ComposerUnused\ComposerUnused\Configuration\Configuration;
use ComposerUnused\ComposerUnused\Configuration\NamedFilter;
use ComposerUnused\ComposerUnused\Configuration\PatternFilter;
use Webmozart\Glob\Glob;

return static function (Configuration $config): Configuration {
    return $config
        ->addPatternFilter(PatternFilter::fromString('/ext-.*/'))
        ->addPatternFilter(PatternFilter::fromString('/laravel\/.*/'))
        ->addNamedFilter(NamedFilter::fromString('guzzlehttp/guzzle'))
        ->addNamedFilter(NamedFilter::fromString('jaybizzle/laravel-migrations-organiser'))
        ->setAdditionalFilesFor('icanhazstring/composer-unused', [
            __FILE__,
            ...Glob::glob(__DIR__ . '/config/*.php'),
        ]);
};
