<?php

declare(strict_types=1);

use PhpCsFixer\Fixer\ArrayNotation\NoMultilineWhitespaceAroundDoubleArrowFixer;
use PhpCsFixer\Fixer\CastNotation\CastSpacesFixer;
use PhpCsFixer\Fixer\ClassNotation\ClassAttributesSeparationFixer;
use PhpCsFixer\Fixer\ClassNotation\ClassDefinitionFixer;
use PhpCsFixer\Fixer\ControlStructure\YodaStyleFixer;
use PhpCsFixer\Fixer\FunctionNotation\NativeFunctionInvocationFixer;
use PhpCsFixer\Fixer\FunctionNotation\SingleLineThrowFixer;
use PhpCsFixer\Fixer\Import\OrderedImportsFixer;
use PhpCsFixer\Fixer\LanguageConstruct\DeclareEqualNormalizeFixer;
use PhpCsFixer\Fixer\Operator\BinaryOperatorSpacesFixer;
use PhpCsFixer\Fixer\Operator\ConcatSpaceFixer;
use PhpCsFixer\Fixer\Operator\IncrementStyleFixer;
use PhpCsFixer\Fixer\Operator\NotOperatorWithSuccessorSpaceFixer;
use PhpCsFixer\Fixer\Phpdoc\NoSuperfluousPhpdocTagsFixer;
use PhpCsFixer\Fixer\Phpdoc\PhpdocAlignFixer;
use PhpCsFixer\Fixer\Phpdoc\PhpdocNoPackageFixer;
use PhpCsFixer\Fixer\Phpdoc\PhpdocSeparationFixer;
use PhpCsFixer\Fixer\Phpdoc\PhpdocSummaryFixer;
use PhpCsFixer\Fixer\Phpdoc\PhpdocToCommentFixer;
use PhpCsFixer\Fixer\PhpTag\BlankLineAfterOpeningTagFixer;
use PhpCsFixer\Fixer\Whitespace\BlankLineBeforeStatementFixer;
use PhpCsFixer\Fixer\Whitespace\HeredocIndentationFixer;
use PhpCsFixer\Fixer\Whitespace\NoExtraBlankLinesFixer;
use Symplify\EasyCodingStandard\Config\ECSConfig;

return ECSConfig::configure()
    ->withPaths([
        __DIR__ . '/src',
        __DIR__ . '/tests',
    ])
    ->withPreparedSets(psr12: true, common: true, cleanCode: true)
    ->withConfiguredRule(
        IncrementStyleFixer::class,
        [
            'style' => 'post',
        ],
    )
    ->withConfiguredRule(
        YodaStyleFixer::class,
        [
            'equal' => false,
            'identical' => false,
            'less_and_greater' => false,
        ],
    )
    ->withConfiguredRule(
        ConcatSpaceFixer::class,
        [
            'spacing' => 'one',
        ],
    )
    ->withConfiguredRule(
        CastSpacesFixer::class,
        [
            'space' => 'none',
        ],
    )
    ->withConfiguredRule(
        OrderedImportsFixer::class,
        [
            'imports_order' => ['class', 'function', 'const'],
        ],
    )
    ->withConfiguredRule(
        NoSuperfluousPhpdocTagsFixer::class,
        [
            'remove_inheritdoc' => false,
            'allow_mixed' => true,
            'allow_unused_params' => false,
        ],
    )
    ->withConfiguredRule(
        DeclareEqualNormalizeFixer::class,
        [
            'space' => 'none',
        ],
    )
    ->withConfiguredRule(
        BlankLineBeforeStatementFixer::class,
        [
            'statements' => ['continue', 'declare', 'return', 'throw', 'try'],
        ],
    )
    ->withConfiguredRule(
        BinaryOperatorSpacesFixer::class,
        [
            'operators' => ['&' => 'align'],
        ],
    )
    ->withConfiguredRule(
        // https://github.com/nunomaduro/phpinsights/blob/master/docs/insights/style.md#no-extra-blank-lines---
        NoExtraBlankLinesFixer::class,
        [
            'tokens' =>
                [
                    'break',
                    'case',
                    'continue',
                    'curly_brace_block',
                    'default',
                    'extra',
                    'parenthesis_brace_block',
                    'return',
                    'square_brace_block',
                    'switch',
                    'throw',
                    //'use',
                    'use_trait',
                ],
        ],
    )
    ->withConfiguredRule(
        ClassDefinitionFixer::class,
        [
            'multi_line_extends_each_single_line' => true,
        ],
    )
    ->withSkip([
        NoMultilineWhitespaceAroundDoubleArrowFixer::class => null,
        PhpdocNoPackageFixer::class => null,
        PhpdocSummaryFixer::class => null,
        PhpdocSeparationFixer::class => null,
        BlankLineAfterOpeningTagFixer::class => null,
        ClassAttributesSeparationFixer::class => null,
        NotOperatorWithSuccessorSpaceFixer::class => null,
        SingleLineThrowFixer::class => null,
        PhpdocAlignFixer::class => null,
        HeredocIndentationFixer::class => null,
        PhpdocToCommentFixer::class => null,
        NativeFunctionInvocationFixer::class => null,
    ]);
