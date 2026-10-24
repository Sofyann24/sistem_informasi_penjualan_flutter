<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use Illuminate\Http\Request;
use Psr\Http\Message\ResponseInterface;

class CustomerController extends Controller
{
    public function index()
    {
        $customers = Customer::orderBy('name_customer', 'asc')->get();

        return response()->json([
            'status' => 'success',
            'message' => 'Pelanggan berhasil ditambahkan',
            'data' => $customers
        ], 201);
    }

    public function store(Request $request)
    {
        $validate = $request->validate([
            'name_customer' => 'required|string|max:255|unique:customers,name_customer',
            'phone_number' => 'required|string|max:255|unique:customers,phone_number',
            'address' => 'nullable|string|max:255|unique:customers,address'
        ]);

        $customer = Customer::create($validate);

        return response([
            'status' => 'success',
            'message' => 'Pelanggan berhasil ditambahkan',
            'data' => $customer
        ], 201);
    }

    public function show(int $id)
    {
        try {
            $customer = Customer::find($id);

            if (!$customer) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Data pelanggan tidak ada'
                ], 404);
            }

            return response()->json([
                'satus' => 'success',
                'message' => 'Data pelanggan berhasil diambil',
                'data' => $customer
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'gagal mengambil data',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function update(Request $request, int $id)
    {
        try {
            $customer = Customer::find($id);

            if (!$customer) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Data customer tidak ditemukan',

                ], 404);
            }

            $validate = $request->validate([
                'name' => ['required', 'string', 'max:255', 'unique:customers,name_customer'],
                'phone_number' => 'nullable|string|max:255',
                'address' => 'nullable|string|max:255'
            ]);

            $customer->update([
                'name_customer' => $validate['name'],
                'phone_number' => $validate['phone_number'] ?? $customer->phone_number,
                'address' => $validate['address'] ?? $customer->address
            ]);
            return response()->json([
                'status' => 'success',
                'message' => 'Data pelanggan berhasil diupdate',
                'data' => $customer
            ], 200);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'error' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal update data pelanggan',
                'error' => $e->getMessage()
            ], 422);
        }
    }

    public function destroy($id)
    {
        try {
            $customer = Customer::find($id);

            if (!$customer) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Data customer tidak ditemukan',

                ], 200);
            }

            $customer->delete();
            return response()->json([
                'status' => 'success',
                'message' => 'Customer berhasil dihapus',
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal hapus data pelanggan',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
