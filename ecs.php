<?php

declare(strict_types=1);

use PhpCsFixer\Fixer\ArrayNotation\NoMultilineWhitespaceAroundDoubleArrowFixer;
use PhpCsFixer\Fixer\CastNotation\CastSpacesFixer;
use PhpCsFixer\Fixer\ClassNotation\ClassAttributesSeparationFixer;
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
use Symplify\EasyCodingStandard\ValueObject\Set\SetList;

return static function (ECSConfig $ecsConfig): void {
    $ecsConfig->paths([
        __DIR__ . '/src',
        __DIR__ . '/tests',
    ]);

    $ecsConfig->sets([SetList::PSR_12, SetList::CLEAN_CODE, SetList::COMMON]);

    $ruleConfigurations = [
        [
            IncrementStyleFixer::class,
            ['style' => 'post'],
        ],
        [
            YodaStyleFixer::class,
            [
                'equal' => false,
                'identical' => false,
                'less_and_greater' => false,
            ],
        ],
        [
            ConcatSpaceFixer::class,
            ['spacing' => 'one'],
        ],
        [
            CastSpacesFixer::class,
            ['space' => 'none'],
        ],
        [
            OrderedImportsFixer::class,
            ['imports_order' => ['class', 'function', 'const']],
        ],
        [
            NoSuperfluousPhpdocTagsFixer::class,
            [
                'remove_inheritdoc' => false,
                'allow_mixed' => true,
                'allow_unused_params' => false,
            ],
        ],
        [
            DeclareEqualNormalizeFixer::class,
            ['space' => 'none'],
        ],
        [
            BlankLineBeforeStatementFixer::class,
            ['statements' => ['continue', 'declare', 'return', 'throw', 'try']],
        ],
        [
            BinaryOperatorSpacesFixer::class,
            ['operators' => ['&' => 'align']],
        ],
        [
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
        ],
    ];

    array_map(static fn ($parameters) => $ecsConfig->ruleWithConfiguration(...$parameters), $ruleConfigurations);

    $ecsConfig->skip([
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
};
