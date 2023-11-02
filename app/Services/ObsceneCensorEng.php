<?php

namespace App\Services;

class ObsceneCensorEng
{
    const SEPARATOR_PLACEHOLDER = '{!!}';

    /**
     * Escaped separator characters
     */
    protected $escapedSeparatorCharacters = [
        '\s',
    ];

    /**
     * Unescaped separator characters.
     * @var array
     */
    protected $separatorCharacters = [
    ];


    /**
     * List of potential character substitutions as a regular expression.
     *
     * @var array
     */
    protected $characterSubstitutions = [
    ];

    /**
     * List of profanities to test against.
     *
     * @var array
     */
    protected $profanities = [];
    protected $separatorExpression;
    protected $characterExpressions;

    /**
     * @param null $config
     */
    public function __construct($config = null)
    {
        if ($config === null) {
            $config = __DIR__ . '/profanities.php';
        }

        if (is_array($config)) {
            $this->profanities = $config;
        } else {
            $this->profanities = $this->loadProfanitiesFromFile($config);
        }

        $this->separatorExpression = $this->generateSeparatorExpression();
        $this->characterExpressions = $this->generateCharacterExpressions();
    }

    /**
     * Load 'profanities' from config file.
     *
     * @param $config
     *
     * @return array
     */
    private function loadProfanitiesFromFile($config): array
    {
        return include($config);
    }

    /**
     * Generates the separator regular expression.
     *
     * @return string
     */
    private function generateSeparatorExpression(): string
    {
        return $this->generateEscapedExpression($this->separatorCharacters, $this->escapedSeparatorCharacters);
    }

    /**
     * Generates the separator regex to test characters in between letters.
     *
     * @param array $characters
     * @param array $escapedCharacters
     * @param string $quantifier
     *
     * @return string
     */
    private function generateEscapedExpression(
        array $characters = [],
        array $escapedCharacters = [],
              $quantifier = '*?'
    ) {
        $regex = $escapedCharacters;
        foreach ($characters as $character) {
            $regex[] = preg_quote($character, '/');
        }

        return '[' . implode('', $regex) . ']' . $quantifier;
    }

    /**
     * Generates a list of regular expressions for each character substitution.
     *
     * @return array
     */
    protected function generateCharacterExpressions()
    {
        $characterExpressions = [];
        foreach ($this->characterSubstitutions as $character => $substitutions) {
            $characterExpressions[$character] = $this->generateEscapedExpression(
                    $substitutions,
                    [],
                    '+?'
                ) . self::SEPARATOR_PLACEHOLDER;
        }

        return $characterExpressions;
    }

    /**
     * Obfuscates string that contains a 'profanity'.
     *
     * @param $string
     *
     * @return string
     */
    public function obfuscateIfProfane($string)
    {
        if ($this->hasProfanity($string)) {
            $string = str_repeat("*", strlen($string));
        }

        return $string;
    }

    /**
     * Checks string for profanities based on list 'profanities'
     *
     * @param $string
     *
     * @return bool
     */
    public function hasProfanity($string)
    {
        if (empty($string)) {
            return false;
        }

        $profanities = [];
        $profanityCount = count($this->profanities);

        for ($i = 0; $i < $profanityCount; $i++) {
            $profanities[$i] = $this->generateProfanityExpression(
                $this->profanities[$i],
                $this->characterExpressions,
                $this->separatorExpression
            );
        }

        foreach ($profanities as $profanity) {
            if ($this->stringHasProfanity($string, $profanity)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Generate a regular expression for a particular word
     *
     * @param $word
     * @param $characterExpressions
     * @param $separatorExpression
     *
     * @return mixed
     */
    protected function generateProfanityExpression($word, $characterExpressions, $separatorExpression)
    {
        $expression = '/' . preg_replace(
                array_keys($characterExpressions),
                array_values($characterExpressions),
                $word
            ) . '/i';

        return str_replace(self::SEPARATOR_PLACEHOLDER, $separatorExpression, $expression);
    }

    /**
     * Checks a string against a profanity.
     *
     * @param $string
     * @param $profanity
     *
     * @return bool
     */
    private function stringHasProfanity($string, $profanity)
    {
        return preg_match($profanity, $string) === 1;
    }
}


