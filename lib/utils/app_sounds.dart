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
      await _player.setAudioContext(
        AudioContext(
          // Use default values or specify parameters as supported by the package version
          // For web, AudioContext has a 'config' parameter in some versions, or just use the default constructor
        ),
      );
    }
  }
}
