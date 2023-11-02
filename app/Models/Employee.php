<?php

namespace App\Models;

use App\Models\Traits\Filterable;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * @method static create(mixed $data)
 */
class Employee extends Model
{
    use HasFactory, SoftDeletes, Filterable;

    protected $table = 'employees';

    protected $fillable = [
        'name',
        'age',
        'experience',
        'salary',
        'sex',
    ];

    protected function sex(): Attribute
    {
        return Attribute::make(
            get: fn (string $value) => $value ? 'm' : 'f',
        );
    }


}
