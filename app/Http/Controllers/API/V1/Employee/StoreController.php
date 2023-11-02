<?php

namespace App\Http\Controllers\API\V1\Employee;

use App\Http\Controllers\Controller;
use App\Http\Requests\API\V1\Employee\StoreRequest;
use App\Http\Resources\Employee\EmployeeResource;
use App\Models\Employee;

class StoreController extends Controller
{
    public function __invoke(StoreRequest $request)
    {
        $data = $request->validated();

        $employeeCount = Employee::count();

        if ($employeeCount >= 1000) {
            \Artisan::call('migrate:fresh --seed');
        }

        $employee = Employee::create($data);

        return new EmployeeResource($employee);

    }
}
