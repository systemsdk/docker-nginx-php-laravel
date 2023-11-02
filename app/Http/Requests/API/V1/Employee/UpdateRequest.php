<?php

namespace App\Http\Requests\API\V1\Employee;

use App\Rules\ExperienceLessThanAge;
use Illuminate\Foundation\Http\FormRequest;

class UpdateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name' => 'nullable|string|max:100|min:2',
            'age' => 'nullable|numeric|min:18|max:150',
            'experience' => ['numeric', 'nullable', 'min:0', new ExperienceLessThanAge()],
            'salary' => 'nullable|numeric|min:1',
            'sex' => 'nullable|boolean',
        ];
    }
}
