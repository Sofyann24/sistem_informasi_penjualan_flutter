<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoriesController;
use App\Http\Controllers\Api\CustomerController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\api\ProfitController;
use App\Http\Controllers\Api\TransactionController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Public Routes (Bisa diakses tanpa token)
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});

// CATEGORY ROUTES
Route::get('/categories', [CategoriesController::class, 'index']);
Route::post('/categories/store', [CategoriesController::class, 'store']);
Route::delete('/categories/delete/{id}', [CategoriesController::class, 'destroy']);

// PRODUCT ROUTES
Route::get('/products', [ProductController::class, 'index']);
Route::post('/products/store', [ProductController::class, 'store']);
Route::get('/products/show/{id}', [ProductController::class, 'show']);
Route::put('/products/update/{id}', [ProductController::class, 'update']);
Route::delete('/products/delete/{id}', [ProductController::class, 'destroy']);

// CUSTOMER ROUTES
Route::get('/customers', [CustomerController::class, 'index']);
Route::post('/customers/store', [CustomerController::class, 'store']);
Route::get('/customers/show/{id}', [CustomerController::class, 'show']);
Route::put('/customers/update/{id}', [CustomerController::class, 'update']);
Route::delete('/customers/delete/{id}', [CustomerController::class, 'destroy']);

// TRANSACTION ROUTES
Route::get('/transaction', [TransactionController::class, 'index']);
Route::post('/transaction/store', [TransactionController::class, 'store']);
Route::get('transaction/show/{id}', [TransactionController::class, 'show']);
Route::delete('transaction/delete/{id}', [TransactionController::class, 'destroy']);


// PROFIT ROUTES
Route::prefix('dashboard')->group(function () {
    Route::get('/today', [ProfitController::class, 'todaySummary']);
    Route::get('/weekly', [ProfitController::class, 'weeklySummary']);
    Route::get('/range', [ProfitController::class, 'rangeSummary']);
});
