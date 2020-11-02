<?php
declare(strict_types = 1);

use PhpCsFixer\Fixer\ArrayNotation\NoMultilineWhitespaceAroundDoubleArrowFixer;
use PhpCsFixer\Fixer\CastNotation\CastSpacesFixer;
use PhpCsFixer\Fixer\ClassNotation\ClassAttributesSeparationFixer;
use PhpCsFixer\Fixer\ControlStructure\YodaStyleFixer;
use PhpCsFixer\Fixer\FunctionNotation\SingleLineThrowFixer;
use PhpCsFixer\Fixer\Import\OrderedImportsFixer;
use PhpCsFixer\Fixer\LanguageConstruct\DeclareEqualNormalizeFixer;
use PhpCsFixer\Fixer\NamespaceNotation\NoBlankLinesBeforeNamespaceFixer;
use PhpCsFixer\Fixer\NamespaceNotation\SingleBlankLineBeforeNamespaceFixer;
use PhpCsFixer\Fixer\Operator\ConcatSpaceFixer;
use PhpCsFixer\Fixer\Operator\IncrementStyleFixer;
use PhpCsFixer\Fixer\Operator\NotOperatorWithSuccessorSpaceFixer;
use PhpCsFixer\Fixer\Phpdoc\NoSuperfluousPhpdocTagsFixer;
use PhpCsFixer\Fixer\Phpdoc\PhpdocAlignFixer;
use PhpCsFixer\Fixer\Phpdoc\PhpdocNoPackageFixer;
use PhpCsFixer\Fixer\Phpdoc\PhpdocSeparationFixer;
use PhpCsFixer\Fixer\Phpdoc\PhpdocSummaryFixer;
use PhpCsFixer\Fixer\PhpTag\BlankLineAfterOpeningTagFixer;
use PhpCsFixer\Fixer\Whitespace\BlankLineBeforeStatementFixer;
use SlevomatCodingStandard\Sniffs\Functions\UnusedParameterSniff;
use SlevomatCodingStandard\Sniffs\Whitespaces\DuplicateSpacesSniff;
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;
use Symplify\CodingStandard\Fixer\ArrayNotation\ArrayListItemNewlineFixer;
use Symplify\CodingStandard\Fixer\ArrayNotation\ArrayOpenerAndCloserNewlineFixer;
use Symplify\CodingStandard\Fixer\Commenting\ParamReturnAndVarTagMalformsFixer;
use Symplify\CodingStandard\Fixer\Strict\BlankLineAfterStrictTypesFixer;

return static function (ContainerConfigurator $containerConfigurator): void {
    $imports = [
        '/tools/03_ecs/vendor/symplify/easy-coding-standard/config/set/psr12.php',
        '/tools/03_ecs/vendor/symplify/easy-coding-standard/config/set/php70.php',
        '/tools/03_ecs/vendor/symplify/easy-coding-standard/config/set/php71.php',
        '/tools/03_ecs/vendor/symplify/easy-coding-standard/config/set/clean-code.php',
        '/tools/03_ecs/vendor/symplify/easy-coding-standard/config/set/common.php',
        '/tools/03_ecs/vendor/symplify/easy-coding-standard/config/set/dead-code.php',
    ];

    array_map(
        [$containerConfigurator, 'import'],
        array_map(static fn (string $path): string => __DIR__ . $path, $imports)
    );

    $services = $containerConfigurator->services();

    $services->set(IncrementStyleFixer::class)
        ->call('configure', [['style' => 'post']]);

    $services->set(YodaStyleFixer::class)
        ->call('configure', [['equal' => false, 'identical' => false, 'less_and_greater' => false]]);

    $services->set(ConcatSpaceFixer::class)
        ->call('configure', [['spacing' => 'one']]);

    $services->set(CastSpacesFixer::class)
        ->call('configure', [['space' => 'none']]);

    $services->set(OrderedImportsFixer::class)
        ->call('configure', [['imports_order' => ['class', 'function', 'const']]]);

    $services->set(NoSuperfluousPhpdocTagsFixer::class)
        ->call('configure', [['remove_inheritdoc' => false, 'allow_mixed' => true, 'allow_unused_params' => true]]);

    $services->set(DeclareEqualNormalizeFixer::class)
        ->call('configure', [['space' => 'single']]);

    $services->set(BlankLineBeforeStatementFixer::class)
        ->call('configure', [['statements' => ['continue', 'declare', 'return', 'throw', 'try']]]);

    $services->set(SingleBlankLineBeforeNamespaceFixer::class);

    $services->set(DuplicateSpacesSniff::class)->property('ignoreSpacesInAnnotation', true);

    $parameters = $containerConfigurator->parameters();

    $parameters->set('skip',
        [
            UnusedParameterSniff::class => null,
            NoMultilineWhitespaceAroundDoubleArrowFixer::class => null,
            PhpdocNoPackageFixer::class => null,
            PhpdocSummaryFixer::class => null,
            PhpdocSeparationFixer::class => null,
            BlankLineAfterOpeningTagFixer::class => null,
            ClassAttributesSeparationFixer::class => null,
            NoBlankLinesBeforeNamespaceFixer::class => null,
            NotOperatorWithSuccessorSpaceFixer::class => null,
            SingleLineThrowFixer::class => null,
            BlankLineAfterStrictTypesFixer::class => null,
            ParamReturnAndVarTagMalformsFixer::class => null,
            PhpdocAlignFixer::class => null,
            ArrayListItemNewlineFixer::class => null,
            ArrayOpenerAndCloserNewlineFixer::class => null,
        ]
    );
};
