<?php

declare(strict_types=1);

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase
{
    /**
     * A basic test example.
     */
    public function testBasicTest(): void
    {
        self::assertTrue(true); /** @phpstan-ignore staticMethod.alreadyNarrowedType */
    }
}
