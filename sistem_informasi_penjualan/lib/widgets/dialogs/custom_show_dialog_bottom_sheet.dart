import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/helpers/helpers.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/utils/utils.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

// SHOW BOTTOM SHEET UPDATE & DELETE
class CustomShowDialogBottomSheet {
  static Future<dynamic> customShowModalBottomSheet({
    required BuildContext context,
    required String title,
    required VoidCallback onEdit,
    required Future<void> Function() onDelete,
    String editLabel = 'Ubah',
    String deleteLabel = 'Hapus',
    Color deleteColor = Colors.red,
  }) async {
    return showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            height: 150,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // EDIT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      onEdit();
                    },
                    child: Text(
                      editLabel,
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                ),

                // DELETE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(bottomSheetContext);

                      await onDelete();
                    },
                    child: Text('Hapus', style: context.textTheme.titleMedium),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// SHOW CART BOTTOM SHEET
void showCartBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Consumer<CartProvider>(
          builder: (BuildContext context, CartProvider value, Widget? child) {
            final cartList = value.items.values.toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    'Total: ${AppFormatters.formatCurrency(value.finalTotalPrice)}',
                    style: context.textTheme.titleMedium,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: ((context, index) {
                        final cart = cartList[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              // INFO PRODUK (EXPANDED)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cart.product.nameProduct,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${AppFormatters.formatQuantity(cart.quantity, cart.product.unit)} x Rp ${AppFormatters.formatCurrency(cart.product.priceSell)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // QUANTITY CONTROL (UKURAN TETAP)
                              SizedBox(
                                width: 150,
                                child: ProductQuantityControl(
                                  product: cart.product,
                                  height: 35,
                                  fontSize: 12,
                                  iconSize: 20,
                                  borderRadius: 8,
                                  showCloseButton: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  CustomButtonLarge(
                    label: 'Checkout',
                    onKlick: () {
                      Navigator.pushNamed(context, 'paymentScreen');
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
