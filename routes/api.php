<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::prefix('v1')->middleware('setLocale')->group(function () {
    Route::get('employees', \App\Http\Controllers\API\V1\Employee\IndexController::class)
        ->name('employees.index');

    Route::post('employees', \App\Http\Controllers\API\V1\Employee\StoreController::class)
    ->name('employees.store');

    Route::patch('employees/{employee}', \App\Http\Controllers\API\V1\Employee\UpdateController::class)
        ->name('employees.update');

    Route::get('employees/{employee}', \App\Http\Controllers\API\V1\Employee\ShowController::class)
        ->name('employees.show');

    Route::delete('employees/{employee}', \App\Http\Controllers\API\V1\Employee\DeleteController::class)
        ->name('employees.delete');


});
