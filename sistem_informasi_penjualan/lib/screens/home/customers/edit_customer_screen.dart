import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/providers/customers_provider.dart';
import 'package:sistem_informasi_penjualan/widgets/customs/custom_text_form.dart';

class EditCustomerScreen extends StatefulWidget {
  const EditCustomerScreen({super.key});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCustomerController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final customerProvider = Provider.of<CustomersProvider>(
        context,
        listen: false,
      );

      final inputSuccess = await customerProvider.addCustomer(
        _nameCustomerController.text.trim(),
        _phoneNumberController.text.trim(),
        _addressController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (inputSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil menambahkan pelanggan')),
        );

        Navigator.pop(context);
      } else {
        final errorMsg =
            customerProvider.errorMessage ?? 'Gagal menambahkan pelanggan';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomersProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Pelanggan')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  spacing: 20,
                  children: [
                    CustomTextForm(
                      label: 'Nama Pelanggan',
                      hint: 'Ujang',
                      controller: _nameCustomerController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan nama pelanggan';
                        }
                        if (customerProvider.isCustomerExist(
                          _nameCustomerController.text,
                        )) {
                          return 'Data pelanggan sudah ada';
                        }
                        return null;
                      },
                    ),
                    CustomTextForm(
                      label: 'Nomor Handphone',
                      hint: '0812xxxxxxxx',
                      controller: _phoneNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor handphone sudah ada';
                        }
                        if (customerProvider.isCustomerExist(
                          _phoneNumberController.text,
                        )) {
                          return 'Nomor handphone sudah ada';
                        }
                        return null;
                      },
                    ),
                    CustomTextForm(
                      label: 'Alamat Rumah Pelanggan',
                      hint: 'Jl. Kesana',
                      controller: _addressController,
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return 'Masukkan Alamat Rumah';
                        // }
                        if (customerProvider.isCustomerExist(
                          _addressController.text,
                        )) {
                          return 'Alamat pelanggan sudah ada';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _onSavePressed();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2393F0),
                    ),
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
