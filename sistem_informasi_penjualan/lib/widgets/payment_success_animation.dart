import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccessAnimation extends StatefulWidget {
  final String? message;
  final VoidCallback? onCompleted;

  const PaymentSuccessAnimation({super.key, this.message, this.onCompleted});

  @override
  State<PaymentSuccessAnimation> createState() =>
      _PaymentSuccessAnimationState();
}

class _PaymentSuccessAnimationState extends State<PaymentSuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    // AUDIO PLAYER
    _audioPlayer = AudioPlayer();

    // ANIMASI CONTROLLER
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // PLAY SOUND + ANIMASI
    _controller.forward();

    // PLAY SOUND PAS ANIMASI MULAI
    _playSound();

    // SETELAH ANIMASI SELESAI, TUNGGU LALU COMPLETE
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 0), () {
          widget.onCompleted?.call();
        });
      }
    });
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/success.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // LOTTIE ANIMATION
          Lottie.asset(
            'assets/animations/check_mark.json',
            width: 200,
            height: 200,
            repeat: false,
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
            },
          ),
          const SizedBox(height: 16),

          // TEXT
          Text(
            widget.message ?? 'Pembayaran Berhasil!',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
