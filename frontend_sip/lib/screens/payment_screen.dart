import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/helpers/helpers.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/screens/screens.dart';
import 'package:sistem_informasi_penjualan/utils/utils.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'Cash';
  final TextEditingController _inputAmountCash = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomersProvider>().fetchCustomers();
    });
  }

  Future<void> _onCheckoutPressed() async {
    final cartProvider = context.read<CartProvider>();

    if (cartProvider.items.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Keranjang kosong!')));
      return;
    }

    // int totalPrice = 0;
    // int totalProfit = 0;
    // double totalItems = 0;

    // for (final item in cartProvider.items.values) {
    //   final subtotal = item.quantity * item.product.priceSell;
    //   final profit =
    //       item.quantity * (item.product.priceSell - item.product.priceBuy);

    //   totalPrice += subtotal.toInt();
    //   totalProfit += profit.toInt();
    //   totalItems += item.quantity;
    // }

    final items = cartProvider.items.values.map((item) {
      return {
        'product_id': item.product.id,
        'quantity': item.quantity,
        'price': item.product.priceSell,
        'subtotal': item.subtotal,
        'profit': item.profit,
      };
    }).toList();

    final success = await context.read<TransactionProvider>().storeTransaction(
      customerId: cartProvider.selectedCustomer.id,
      totalPrice: cartProvider.totalPrice,
      totalProfit: cartProvider.totalProfit,
      totalItems: cartProvider.items.length.toDouble(),
      paymentMethod: _selectedPaymentMethod,
      status: _selectedPaymentMethod == 'Hutang' ? 'Belum Lunas' : 'Lunas',
      notes: null,
      items: items,
    );

    if (success && mounted) {
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.7),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Center(
            child: PaymentSuccessAnimation(
              message: 'Pembayaran Berhasil!',
              onCompleted: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLayout()),
                  (route) => false, // HAPUS SEMUA ROUTE
                );
                cartProvider.resetItems();
              },
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cartList = cartProvider.items.values.toList();
    final customerProvider = context.watch<CustomersProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Halaman Pembayaran'), elevation: 4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, index) {
                    return Divider(thickness: 1);
                  },
                  itemCount: cartList.length,
                  itemBuilder: (BuildContext context, index) {
                    final cart = cartList[index];
                    return ListTile(
                      title: Text(cart.product.nameProduct),
                      subtitle: Text(
                        '${AppFormatters.formatQuantity(cart.quantity, cart.product.unit)} X ${AppFormatters.formatCurrency(cart.product.priceSell)}',
                      ),
                      trailing: Text(
                        AppFormatters.formatCurrency(cart.totalPrice),
                        style: context.textTheme.bodyLarge,
                      ),
                    );
                  },
                ),
              ),

              // AMOUNT PRICE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppFormatters.formatCurrency(cartProvider.finalTotalPrice),
                    style: context.textTheme.titleLarge,
                  ),
                ],
              ),
              Divider(),

              // INPUT CASH
              ButtonInputCash(
                finalTotalPrice: cartProvider.finalTotalPrice,
                controller: _inputAmountCash,
              ),
              SizedBox(height: 10),


              // CUSTOMER DROPDOWN
              CustomDropdown<CustomerModel>(
                hintText: 'Pilih Pelanggan',
                items: [
                  CustomerModel.defaultCustomer,
                  ...customerProvider.customers,
                ],
                itemAsString: (cust) => cust.nameCustomer,
                onSelected: (value) {
                  setState(() {
                    customerProvider.setCustomer(value);
                  });
                },
                selectedItem: cartProvider.selectedCustomer,
                compareFn: (a, b) => a.id == b.id,
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButtonLarge(
                      height: 60,
                      borderRadius: BorderRadius.circular(2),
                      colors: _selectedPaymentMethod == 'Hutang'
                          ? Colors.blue
                          : Colors.white,
                      label: 'Hutang',
                      textColor: _selectedPaymentMethod == 'Hutang'
                          ? Colors.white
                          : Colors.blue,
                      onKlick: () {
                        setState(() {
                          _selectedPaymentMethod = 'Hutang';
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomButtonLarge(
                      height: 60,
                      borderRadius: BorderRadius.circular(2),
                      colors: _selectedPaymentMethod == 'Cash'
                          ? Colors.blue
                          : Colors.white,
                      label: 'Cash',
                      textColor: _selectedPaymentMethod == 'Cash'
                          ? Colors.white
                          : Colors.blue,
                      onKlick: () {
                        setState(() {
                          _selectedPaymentMethod = 'Cash';
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomButtonLarge(
                label: 'Bayar',
                onKlick: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Konfirmasi Pembayaran'),
                        content: Column(
                          spacing: 6,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total belanja: ${AppFormatters.formatCurrency(cartProvider.finalTotalPrice)}',
                              style: context.textTheme.bodyLarge,
                            ),
                            Text(
                              'Nama pelanggan: ${customerProvider.selectedCustomer.nameCustomer}',
                              style: context.textTheme.bodyLarge,
                            ),
                            Text(
                              'Pembayaran: $_selectedPaymentMethod',
                              style: context.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Batal',
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _onCheckoutPressed();

                              Navigator.pop(context);
                            },
                            child: Text(
                              'Bayar',
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
