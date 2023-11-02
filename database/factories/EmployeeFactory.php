<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Employee>
 */
class EmployeeFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => $this->faker->name,
            'age' => $this->faker->numberBetween(18, 65),
            'experience' => $this->faker->optional(0.6, 0)->numberBetween(0, 20),
            'salary' => $this->faker->numberBetween(1000, 10000),
            'sex' => $this->faker->boolean,
        ];
    }
}
