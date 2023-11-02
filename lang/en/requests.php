<?php

return [
    'name' => [
        'required' => "Name is required",
        'max' => "Maximum characters allowed for the name is 100",
        'min' => "Minimum characters required for the name is 2",
        'is_obscene' => "Calm down!",
    ],

    'age' => [
        'required' => "Age is required",
        'min' => "Age must be greater than 18",
        'max' => "Age must be less than 150",
    ],
    'salary' => [
        'required' => "Salary is mandatory",
        'min' => "Salary must be a minimum of 1",
    ],
    'experience' => [
        'min' => 'Experience must be greater than or equal to 0'
    ],
    'sex' => [
        'required' => 'Gender must be specified',
        'boolean' => 'Gender must be a boolean value',
    ]
];

