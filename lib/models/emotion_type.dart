import 'package:flutter/material.dart';

enum EmotionType {
  sadness,
  anxiety,
  anger,
  fear,
  loneliness,
  frustration,
  guilt,
  jealousy,
  hopelessness,
  shame,
}

extension EmotionTypeExtension on EmotionType {
  String get title {
    switch (this) {
      case EmotionType.sadness:
        return "الحزن";
      case EmotionType.anxiety:
        return "القلق";
      case EmotionType.anger:
        return "الغضب";
      case EmotionType.fear:
        return "الخوف";
      case EmotionType.loneliness:
        return "الوحدة";
      case EmotionType.frustration:
        return "الإحباط";
      case EmotionType.guilt:
        return "الذنب";
      case EmotionType.jealousy:
        return "الغيرة";
      case EmotionType.hopelessness:
        return "اليأس";
      case EmotionType.shame:
        return "العار";
    }
  }

  String get description {
    switch (this) {
      case EmotionType.sadness:
        return "شعور عميق بالحزن والتعب النفسي المصحوب بالبكاء وفقدان الاهتمام";
      case EmotionType.anxiety:
        return "شعور مزعج بالخوف والتوتر مع أعراض جسدية مثل تسارع ضربات القلب";
      case EmotionType.anger:
        return "استجابة قوية للإحباط أو الظلم مع رغبة في التعبير عن الاستياء";
      case EmotionType.fear:
        return "شعور بعدم الأمان أو الخطر، غالباً ما يكون ناتج عن تهديد فعلي أو متوقع";
      case EmotionType.loneliness:
        return "إحساس بالعزلة والانفصال عن الآخرين حتى مع وجودهم حولك";
      case EmotionType.frustration:
        return "شعور بالإحباط نتيجة عوائق تمنعك من تحقيق ما ترغب به";
      case EmotionType.guilt:
        return "إحساس بالذنب نتيجة تصرفات أو قرارات تشعر أنها خاطئة";
      case EmotionType.jealousy:
        return "رغبة قوية في امتلاك ما يملكه الآخرون مع مشاعر بعدم الرضا";
      case EmotionType.hopelessness:
        return "فقدان الأمل والإحساس بعدم جدوى المحاولة أو التغيير";
      case EmotionType.shame:
        return "شعور بعدم القيمة أو الخجل من الذات نتيجة أفعال أو نظرة الآخرين";
    }
  }

  IconData get icon {
    switch (this) {
      case EmotionType.sadness:
        return Icons.mood_bad;
      case EmotionType.anxiety:
        return Icons.error_outline;
      case EmotionType.anger:
        return Icons.whatshot;
      case EmotionType.fear:
        return Icons.warning_amber_rounded;
      case EmotionType.loneliness:
        return Icons.person_outline;
      case EmotionType.frustration:
        return Icons.sentiment_neutral;
      case EmotionType.guilt:
        return Icons.thumb_down;
      case EmotionType.jealousy:
        return Icons.compare_arrows;
      case EmotionType.hopelessness:
        return Icons.hourglass_disabled;
      case EmotionType.shame:
        return Icons.visibility_off;
    }
  }

  Color get color {
    switch (this) {
      case EmotionType.sadness:
        return Colors.blueGrey;
      case EmotionType.anxiety:
        return Colors.orange;
      case EmotionType.anger:
        return Colors.red;
      case EmotionType.fear:
        return Colors.deepPurple;
      case EmotionType.loneliness:
        return Colors.grey;
      case EmotionType.frustration:
        return Colors.brown;
      case EmotionType.guilt:
        return Colors.indigo;
      case EmotionType.jealousy:
        return Colors.teal;
      case EmotionType.hopelessness:
        return Colors.black45;
      case EmotionType.shame:
        return Colors.deepOrangeAccent;
    }
  }
}
