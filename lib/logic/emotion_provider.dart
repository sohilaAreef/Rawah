import 'package:flutter/foundation.dart';
import 'package:rawah/models/daily_emotion.dart';
import 'package:rawah/services/emotion_service.dart';

class EmotionProvider with ChangeNotifier {
  final EmotionService _emotionService = EmotionService();
  List<DailyEmotion> _emotions = [];

  List<DailyEmotion> get emotions => _emotions;

  Future<void> loadEmotions() async {
    try {
      _emotions = await _emotionService.getWeeklyEmotions();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading emotions: $e');
      }
    }
  }

  Future<void> addEmotion(DailyEmotion emotion) async {
    try {
      await _emotionService.addDailyEmotion(emotion);
      _emotions.add(emotion);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding emotion: $e');
      }
    }
  }
}
