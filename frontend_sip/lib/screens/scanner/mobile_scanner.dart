import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/helpers/helpers.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'package:sistem_informasi_penjualan/widgets/widgets.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({
    super.key,
    this.onBarcodeScanned,
    required this.autoClose,
  });
  final Function(String)? onBarcodeScanned;
  final bool autoClose;

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  final List<String> _scannedBarcodes = [];

  bool _isScanned = false;
  bool _isTorchOn = false;
  bool _isFrontCamera = false;
  DateTime? _lastScanTime;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;
    final now = DateTime.now();
    if (_lastScanTime != null &&
        now.difference(_lastScanTime!).inMilliseconds < 500) {
      debugPrint('⚠️ Debounce, skip');
      return;
    }
    _lastScanTime = now;
    _isScanned = true;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    _isScanned = true;
    _lastScanTime = now;
    SoundHelper.playBeep();

    debugPrint('📷 Barcode: $code');

    if (widget.onBarcodeScanned != null) {
      widget.onBarcodeScanned!(code);
    }

    if (widget.autoClose) {
      // TUTUP SCANNER
      Navigator.pop(context, code);
    } else {
      // TETEP KEBUKA + TAMBAH KE LIST
      setState(() {
        _scannedBarcodes.add(code);
      });
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isScanned = false);
      }
    });

    // Navigator.pop(context, code);
  }

  Future<void> _toggleTorch() async {
    try {
      await _controller.toggleTorch();
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> _switchCamera() async {
    try {
      await _controller.switchCamera();
      setState(() {
        _isFrontCamera = !_isFrontCamera;
      });
      debugPrint('📷 Camera: ${_isFrontCamera ? "Front" : "Back"}');
    } catch (e) {
      debugPrint('❌ Error switch camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Produk')),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 8),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _toggleTorch,
                  icon: Icon(
                    _isTorchOn ? Icons.flash_off : Icons.flash_on,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: _switchCamera,
                  icon: Icon(
                    _isFrontCamera
                        ? Icons.flip_camera_android_outlined
                        : Icons.flip_camera_android,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemsCount == 0) {
            return const SizedBox.shrink();
          }
          return Badge(
            label: Text('${cart.itemsCount}'),
            child: FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              onPressed: () {
                showCartBottomSheet(context);
              },
              child: Icon(Icons.shopping_basket, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
