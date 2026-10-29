import 'package:flutter/material.dart';

class CustomButtonLarge extends StatelessWidget {
  const CustomButtonLarge({
    super.key,
    required this.label,
    required this.onKlick,
    this.height,
    this.borderRadius,
    this.colors,
    this.textColor,
  });

  final String label;
  final VoidCallback onKlick;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? colors;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(10),
      ),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
          ),
          backgroundColor: colors ?? Color(0xFF2393F0),
        ),
        onPressed: onKlick,
        child: Text(
          label,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
