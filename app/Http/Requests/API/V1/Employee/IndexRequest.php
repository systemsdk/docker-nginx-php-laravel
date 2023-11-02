<?php

namespace App\Http\Requests\API\V1\Employee;

use Illuminate\Foundation\Http\FormRequest;

class IndexRequest extends FormRequest
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
            'name' => 'nullable|string',
            'sex' => 'nullable|string|in:f,m',
            'salary' => 'nullable|array',
            'salary.min' => 'nullable|numeric',
            'salary.max' => 'nullable|numeric',
            'age' => 'nullable|array',
            'age.min' => 'nullable|numeric',
            'age.max' => 'nullable|numeric',
            'page' => 'nullable|numeric|gt:0',
            'perPage' => 'nullable|numeric|gt:0',
        ];
    }

    protected function prepareForValidation(): void
    {
//        $this->merge([
//            'page' => ($this->page && $this->page < 1) ? 1 : $this->page,
//        ]);
    }
}
