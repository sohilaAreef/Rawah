enum EmotionType {
  happy,
  sad,
  angry,
  anxious,
  excited,
  calm,
  tired,
  neutral,
}

class DailyEmotion {
  final EmotionType type;
  final int intensity; // 1-5
  final DateTime date;

  DailyEmotion({
    required this.type,
    required this.intensity,
    required this.date,
  });
}