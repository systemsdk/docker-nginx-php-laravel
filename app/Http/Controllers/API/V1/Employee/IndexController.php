<?php

namespace App\Http\Controllers\API\V1\Employee;


use App\Http\Controllers\Controller;
use App\Http\Filters\EmployeeFilter;
use App\Http\Requests\API\V1\Employee\IndexRequest;
use App\Http\Resources\Employee\EmployeeResource;
use App\Models\Employee;


class IndexController extends Controller
{
    private const PER_PAGE = 10;
    private const PAGE = 1;
    public function __invoke(IndexRequest $request)
    {
        $data = $request->validated();

        $filter = app()->make(EmployeeFilter::class, ['queryParams' => array_filter($data)]);

        $employees = Employee::filter($filter)
            ->paginate(
                $data['perPage'] ?? self::PER_PAGE,
                ['*'], 'page',
                $data['page'] ?? self::PAGE
            );

        return EmployeeResource::collection($employees);
    }
}
