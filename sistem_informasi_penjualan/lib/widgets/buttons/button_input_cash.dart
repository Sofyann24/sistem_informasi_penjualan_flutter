import 'package:flutter/material.dart';
import 'package:sistem_informasi_penjualan/helpers/helpers.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class ButtonInputCash extends StatefulWidget {
  final double finalTotalPrice;
  final TextEditingController controller;
  final ValueChanged<int>? onPresetSelected;

  const ButtonInputCash({
    super.key,
    required this.finalTotalPrice,
    required this.controller,
    this.onPresetSelected,
  });

  @override
  State<ButtonInputCash> createState() => _ButtonInputCashState();
}

class _ButtonInputCashState extends State<ButtonInputCash> {
  @override
  Widget build(BuildContext context) {
    final presetAmounts = [
      widget.finalTotalPrice, // Pas
      50000.0, // 50rb
      100000.0, // 100rb
    ];

    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // INPUT FIELD
        CustomTextForm(
          label: 'Jumlah Cash',
          hint: AppFormatters.formatCurrency(widget.finalTotalPrice),
          controller: widget.controller, // PAKE CONTROLLER DARI STATE
        ),
        const SizedBox(height: 8),

        // TOMBOL CEPAT
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 8,
          children: presetAmounts.map((amount) {
            return _buildPresetButton(amount);
          }).toList(),
        ),
      ],
    );
  }

  // WIDGET TOMBOL CEPAT
  Widget _buildPresetButton(double amount) {
    final formatted = AppFormatters.formatCurrency(amount);
    final isExact = amount == widget.finalTotalPrice;

    return GestureDetector(
      onTap: () {
        // ISI CONTROLLER PAS DIKLIK
        widget.controller.text = formatted;
        widget.controller.selection = TextSelection.collapsed(
          offset: formatted.length,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isExact ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
          ),
        ),
        child: Text(
          formatted,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isExact ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
