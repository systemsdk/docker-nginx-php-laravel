<?php

namespace App\Http\Controllers\API\V1\Employee;

use App\Http\Controllers\Controller;
use App\Http\Requests\API\V1\Employee\UpdateRequest;
use App\Http\Resources\Employee\EmployeeResource;
use App\Models\Employee;

class ShowController extends Controller
{
    public function __invoke(Employee $employee)
    {
        return new EmployeeResource($employee);
    }
}
