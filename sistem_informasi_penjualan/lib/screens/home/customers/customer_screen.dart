import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final TextEditingController nameCustomerController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // FETCH DATA
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomersProvider>().fetchCustomers();
    });
  }

  // Future<void> _onRefresh() async {
  //   await context.read<CustomersProvider>().fetchCustomers();

  //   await Future.delayed(Duration(seconds: 1));
  // }

  // GET INITIAL
  String _getInitial(String nameInitial) {
    if (nameInitial.trim().isEmpty) return '?';
    return nameInitial.trim()[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomersProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Pelanggan')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(''),
            customerProvider.isLoading
                ? const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 40,
                      duration: Durations.long1,
                    ),
                  )
                : customerProvider.customers.isEmpty
                ? Center(child: Text('Data pelanggan masih kosong'))
                : Expanded(
                    child: ListView.separated(
                      itemCount: customerProvider.customers.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(height: 10);
                      },
                      itemBuilder: (BuildContext context, index) {
                        final customer = customerProvider.customers[index];
                        return Container(
                          padding: EdgeInsets.all(4),
                          child: InkWell(
                            onLongPress: () {
                              CustomShowDialogBottomSheet.customShowModalBottomSheet(
                                context: context,
                                title: 'Pelanggan',
                                onEdit: _showCustomerForm,
                                onDelete: () async {
                                  final confirm =
                                      await DeleteConfirmDialog.show(
                                        context: context,
                                        title: 'Hapus pelanggan',
                                        message: 'Apakah anda yakin ingin menghapus pelanggan ini?',
                                      );
                                  if (!confirm) return;

                                  final success = await context
                                      .read<CustomersProvider>()
                                      .deleteCustomer(customer.id);
                                  if (!mounted) return;

                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${customer.nameCustomer} berhasil dihapus!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.lightBlueAccent,
                                // Color(
                                //   (Random().nextInt(0xffffffff)),
                                // ).withAlpha(0xff),
                                child: Text(_getInitial(customer.nameCustomer)),
                              ),
                              title: Text(customer.nameCustomer),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            // BUTTON ADD CUSTOMER
            CustomButtonLarge(
              label: 'Tambah Data Pelanggan',
              onKlick: () => _showCustomerForm(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCustomerForm({CustomerModel? customer}) async {
    final isEdit = customer != null;
    final provider = context.read<CustomersProvider>();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DynamicFormDialog(
        title: isEdit ? 'Edit Pelanggan' : 'Tambah Pelanggan',
        submitLabel: isEdit ? 'Ubah' : 'Tambah',
        initialValues: isEdit
            ? {
                'name_customer': customer.nameCustomer,
                'phone_number': customer.phoneNumber,
                'address': customer.address,
              }
            : null,
        fields: [
          FormFieldConfig(
            key: 'name_customer',
            label: 'Nama Pelanggan',
            hint: 'Contoh: Burhan',
            isRequired: true,
            validator: (value) {
              if (provider.isCustomerExist(
                value ?? '',
                excludeId: customer?.id,
              )) {
                return 'Data Pelanggan sudah ada';
              }
              return null;
            },
          ),
          FormFieldConfig(
            key: 'phone_number',
            label: 'Nomor Telepon',
            hint: '0812xxxxxxxx',
            keyboardType: TextInputType.phone,
            isRequired: true,
          ),
          FormFieldConfig(
            key: 'address',
            label: 'Alamat',
            hint: 'Jl. Kesana',
            maxLines: 2,
          ),
        ],
        // HANDLE SUBMIT
        onSubmit: (values) async {
          if (isEdit) {
            return await provider.updateCustomer(
              id: customer.id,
              nameCustomer: values['name_customer'],
              phoneNumber: values['phone_number'],
              address: values['address'],
            );
          } else {
            return await provider.addCustomer(
              values['name_customer'],
              values['phone_number'],
              values['address'],
            );
          }
        },
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Pelanggan berhasil diupdate!'
                : 'Pelanggan berhasil ditambahkan!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
