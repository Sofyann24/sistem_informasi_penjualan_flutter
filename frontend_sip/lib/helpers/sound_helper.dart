import 'package:audioplayers/audioplayers.dart';

class SoundHelper {
  static final AudioPlayer _player = AudioPlayer();

  // PLAY BEEP (SCAN BERHASIL)
  static Future<void> playBeep() async {
    try {
      await _player.play(AssetSource('sounds/beep.mp3'));
    } catch (e) {
      print('❌ Error play sound: $e');
    }
  }

  // PLAY ERROR (SCAN GAGAL)
  static Future<void> playError() async {
    try {
      await _player.play(AssetSource('sounds/error.mp3'));
    } catch (e) {
      print('❌ Error play sound: $e');
    }
  }

  // DISPOSE
  static Future<void> dispose() async {
    await _player.dispose();
  }
}
