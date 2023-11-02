<?php

namespace App\Services;

class ObsceneCensorRus {
    public static $log;
    public static $logEx;

    private static $LT_P = 'пПnPp';
    private static $LT_I = 'иИiI1uі';
    private static $LT_E = 'еЕeE';
    private static $LT_D = 'дДdD';
    private static $LT_Z = 'зЗ3zZ3';
    private static $LT_M = 'мМmM';
    private static $LT_U = 'уУyYuU';
    private static $LT_O = 'оОoO0';
    private static $LT_L = 'лЛlL';
    private static $LT_S = 'сСcCsS';
    private static $LT_A = 'аАaA';
    private static $LT_N = 'нНhH';
    private static $LT_G = 'гГgG';
    private static $LT_CH = 'чЧ4';
    private static $LT_K = 'кКkK';
    private static $LT_C = 'цЦcC';
    private static $LT_R = 'рРpPrR';
    private static $LT_H = 'хХxXhH';
    private static $LT_YI = 'йЙy';
    private static $LT_YA = 'яЯ';
    private static $LT_YO = 'ёЁ';
    private static $LT_YU = 'юЮ';
    private static $LT_B = 'бБ6bB';
    private static $LT_T = 'тТtT';
    private static $LT_HS = 'ъЪ';
    private static $LT_SS = 'ьЬ';
    private static $LT_Y = 'ыЫ';


    public static $exceptions = array(
        'команд',
        'рубл',
        'премь',
        'оскорб',
        'краснояр',
        'бояр',
        'ноябр',
        'карьер',
        'мандат',
        'употр',
        'плох',
        'интер',
        'веер',
        'фаер',
        'феер',
        'hyundai',
        'тату',
        'браконь',
        'roup',
        'сараф',
        'держ',
        'слаб',
        'ридер',
        'истреб',
        'потреб',
        'коридор',
        'sound',
        'дерг',
        'подоб',
        'коррид',
        'дубл',
        'курьер',
        'экст',
        'try',
        'enter',
        'oun',
        'aube',
        'ibarg',
        '16',
        'kres',
        'глуб',
        'ebay',
        'eeb',
        'shuy',
        'ансам',
        'cayenne',
        'ain',
        'oin',
        'тряс',
        'ubu',
        'uen',
        'uip',
        'oup',
        'кораб',
        'боеп',
        'деепр',
        'хульс',
        'een',
        'ee6',
        'ein',
        'сугуб',
        'карб',
        'гроб',
        'лить',
        'рсук',
        'влюб',
        'хулио',
        'ляп',
        'граб',
        'ибог',
        'вело',
        'ебэ',
        'перв',
        'eep',
        'ying',
        'laun',
        'чаепитие',
    );

    public static function getFiltered($text, $charset = 'UTF-8') {
        self::filterText($text, $charset);
        return $text;
    }

    public static function isAllowed($text, $charset = 'UTF-8'): bool
    {
        $original = $text;
        self::filterText($text, $charset);
        return $original === $text;
    }

    public static function filterText(&$text, $charset = 'UTF-8'): bool
    {
        $utf8 = 'UTF-8';

        if ($charset !== $utf8) {
            $text = iconv($charset, $utf8, $text);
        }

        preg_match_all('/
\b\d*(
	\w*[' . self::$LT_P . '][' . self::$LT_I . self::$LT_E . '][' . self::$LT_Z . '][' . self::$LT_D . ']\w* # пизда
|
	(?:[^' . self::$LT_I . self::$LT_U . '\s]+|' . self::$LT_N . self::$LT_I . ')?(?<!стра)[' . self::$LT_H . '][' . self::$LT_U . '][' . self::$LT_YI . self::$LT_E . self::$LT_YA . self::$LT_YO . self::$LT_I . self::$LT_L . self::$LT_YU . '](?!иг)\w* # хуй; не пускает "подстрахуй", "хулиган"
|
	\w*[' . self::$LT_B . '][' . self::$LT_L . '](?:
		[' . self::$LT_YA . ']+[' . self::$LT_D . self::$LT_T . ']?
		|
		[' . self::$LT_I . ']+[' . self::$LT_D . self::$LT_T . ']+
		|
		[' . self::$LT_I . ']+[' . self::$LT_A . ']+
	)(?!х)\w* # бля, блядь; не пускает "бляха"
|
	(?:
		\w*[' . self::$LT_YI . self::$LT_U . self::$LT_E . self::$LT_A . self::$LT_O . self::$LT_HS . self::$LT_SS . self::$LT_Y . self::$LT_YA . '][' . self::$LT_E . self::$LT_YO . self::$LT_YA . self::$LT_I . '][' . self::$LT_B . self::$LT_P . '](?!ы\b|ол)\w* # не пускает "еёбы", "наиболее", "наибольшее"...
		|
		[' . self::$LT_E . self::$LT_YO . '][' . self::$LT_B . ']\w*
		|
		[' . self::$LT_I . '][' . /*self::$LT_P .*/ self::$LT_B . '][' . self::$LT_A . ']\w+
		|
		[' . self::$LT_YI . '][' . self::$LT_O . '][' . self::$LT_B . self::$LT_P . ']\w*
	) # ебать
|
	\w*[' . self::$LT_S . '][' . self::$LT_C . ']?[' . self::$LT_U . ']+(?:
		[' . self::$LT_CH . ']*[' . self::$LT_K . ']+
		|
		[' . self::$LT_CH . ']+[' . self::$LT_K . ']*
	)[' . self::$LT_A . self::$LT_O . ']\w* # сука
|
	\w*(?:
		[' . self::$LT_P . '][' . self::$LT_I . self::$LT_E . '][' . self::$LT_D . '][' . self::$LT_A . self::$LT_O . self::$LT_E/* . self::$LT_I*/ . ']?[' . self::$LT_R . '](?!о)\w* # не пускает "Педро"
		|
		[' . self::$LT_P . '][' . self::$LT_E . '][' . self::$LT_D . '][' . self::$LT_E . self::$LT_I . ']?[' . self::$LT_G . self::$LT_K . ']
	) # пидарас
|
	\w*[' . self::$LT_Z . '][' . self::$LT_A . self::$LT_O . '][' . self::$LT_L . '][' . self::$LT_U . '][' . self::$LT_P . ']\w* # залупа
|
	\w*[' . self::$LT_M . '][' . self::$LT_A . '][' . self::$LT_N . '][' . self::$LT_D . '][' . self::$LT_A . self::$LT_O . ']\w* # манда
)\b
/xu', $text, $m);


        $c = count($m[1]);

        /*
        $exclusion=array('хлеба','наиболее');
        $m[1]=array_diff($m[1],$exclusion);
        */

        if ($c > 0) {
            for ($i = 0; $i < $c; $i++) {
                $word = $m[1][$i];
                $word = mb_strtolower($word, $utf8);

                foreach (self::$exceptions as $x) {
                    if (mb_strpos($word, $x) !== false) {
                        if (is_array(self::$logEx)) {
                            $t = &self::$logEx[$m[1][$i]];
                            ++$t;
                        }
                        $word = false;
                        unset($m[1][$i]);
                        break;
                    }
                }

                if ($word) {
                    $m[1][$i] = str_replace(array(' ', ',', ';', '.', '!', '-', '?', "\t", "\n"), '', $m[1][$i]);
                }
            }

            $m[1] = array_unique($m[1]);

            $asterisks = array();
            foreach ($m[1] as $word) {
                if (is_array(self::$log)) {
                    $t = &self::$log[$word];
                    ++$t;
                }
                $asterisks []= str_repeat('*', mb_strlen($word, $utf8));
            }

            $text = str_replace($m[1], $asterisks, $text);

            if ($charset !== $utf8) {
                $text = iconv($utf8, $charset, $text);
            }

            return true;
        } else {
            if ($charset !== $utf8) {
                $text = iconv($utf8, $charset, $text);
            }

            return false;
        }
    }

}


