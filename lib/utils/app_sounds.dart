import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppSounds {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSubGoalComplete() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/subgoal_complete.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> playGoalComplete() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/goal_complete.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> initForWeb() async {
    if (kIsWeb) {
      await _player.setAudioContext(AudioContext());
    }
  }
}
