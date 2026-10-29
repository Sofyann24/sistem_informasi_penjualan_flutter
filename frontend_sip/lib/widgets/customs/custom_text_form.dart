// lib/widgets/labeled_text_field.dart
import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;

  const CustomTextForm({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Container(
          alignment: Alignment.topLeft,
          child: TextFormField(
            textAlign: TextAlign.start,
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
              suffixIcon: suffixIcon,
            ),
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }
}
