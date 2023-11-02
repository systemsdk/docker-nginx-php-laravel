<?php

namespace App\Http\Filters;

use Illuminate\Database\Eloquent\Builder;

class EmployeeFilter extends AbstractFilter
{

    const NAME = 'name';
    const SEX = 'sex';
    const SALARY = 'salary';
    const AGE = 'age';


    protected function getCallbacks(): array
    {
        return [
            self::NAME => [$this, 'name'],
            self::SEX => [$this, 'sex'],
            self::SALARY => [$this, 'salary'],
            self::AGE => [$this, 'age'],
        ];
    }

    public function name(Builder $builder, $value): void
    {
        $builder->where('name', 'LIKE', '%' . $value . '%');
    }

    public function sex(Builder $builder, $value): void
    {
        $builder->where('sex', $value === 'm');
    }


    public function salary(Builder $builder, $value): void
    {
        if (isset($value['min'])) {
            $builder->where('salary', '>=', $value['min']);
        }

        if (isset($value['max'])) {
            $builder->where('salary', '<=', $value['max']);
        }
    }

    public function age(Builder $builder, $value): void
    {
        if (isset($value['min'])) {
            $builder->where('age', '>=', $value['min']);
        }

        if (isset($value['max'])) {
            $builder->where('age', '<=', $value['max']);
        }

    }
}
