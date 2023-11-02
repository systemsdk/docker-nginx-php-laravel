<?php

namespace App\Http\Requests\API\V1\Employee;

use App\Rules\ExperienceLessThanAge;
use App\Rules\IsObscene;
use Illuminate\Foundation\Http\FormRequest;

class StoreRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the error messages for the defined validation rules.
     *
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'name.required' => __('requests.name.required'),
            'name.max' => __('requests.name.max'),
            'name.min' => __('requests.name.min'),
            'age.required' => __('requests.age.required'),
            'age.min' => __('requests.age.min'),
            'age.max' => __('requests.age.max'),
            'salary.required' => __('requests.salary.required'),
            'salary.min' => __('requests.salary.min'),
            'experience.min' => __('requests.experience.min'),
            'sex.required' => __('requests.sex.required'),
            'sex.boolean' => __('requests.sex.boolean'),
        ];
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name' => ['required','string','max:100','min:2', new IsObscene],
            'age' => 'required|numeric|min:18|max:150',
            'experience' => ['numeric', 'nullable', 'min:0', new ExperienceLessThanAge],
            'salary' => 'required|numeric|min:1',
            'sex' => 'required|boolean',
        ];
    }
}
