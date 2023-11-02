<?php

namespace App\Rules;

use App\Services\ObsceneCensorEng;
use App\Services\ObsceneCensorRus;
use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class IsObscene implements ValidationRule
{

    /**
     * Run the validation rule.
     *
     * @param \Closure(string): \Illuminate\Translation\PotentiallyTranslatedString $fail
     */
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        $isFailed = false;

        if (app()->getLocale() === 'uk') {
            if (!ObsceneCensorRus::isAllowed($value)) {
              $isFailed = true;
            };
        }

        if (app()->getLocale() === 'en') {
            $check = new ObsceneCensorEng();

            if ($check->hasProfanity($value)) {
                $isFailed = true;
            }
        }

        if ($isFailed) {
            $fail(__('requests.name.is_obscene'));
        }
    }

}
