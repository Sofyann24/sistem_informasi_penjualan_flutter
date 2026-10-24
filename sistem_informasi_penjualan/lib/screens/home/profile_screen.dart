import 'package:curve_clipper/curve_clipper.dart';
import 'package:flutter/material.dart';
import 'package:sistem_informasi_penjualan/utils/utils.dart';

class ProfileScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Background Image
              CustomClipperWidget(
                mode: ClipperMode.convex,
                heightFromOrigin: 500,
                child: Container(
                  alignment: Alignment.center,
                  height: deviceSize.height * 0.35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/banner_profile.png'),
                      fit: BoxFit.cover,alignment: Alignment.center
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
