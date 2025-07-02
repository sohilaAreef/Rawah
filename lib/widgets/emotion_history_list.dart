import 'package:flutter/material.dart';
import 'package:rawah/models/daily_emotion.dart';
import 'package:rawah/utils/app_colors.dart';

class EmotionHistoryList extends StatelessWidget {
  final List<DailyEmotion> emotions;

  const EmotionHistoryList({super.key, required this.emotions});

  @override
  Widget build(BuildContext context) {
    if (emotions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty.png',
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'لا توجد مشاعر مسجلة بعد',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'سجل مشاعرك اليومية لتراها هنا',
              style: TextStyle(fontSize: 16, color: AppColors.accent),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: emotions.length,
      itemBuilder: (context, index) {
        final emotion = emotions[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getEmotionColor(emotion.type).withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  _getEmotionIcon(emotion.type),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            title: Text(
              _getEmotionName(emotion.type),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  '${emotion.date.day}/${emotion.date.month}/${emotion.date.year}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'الشدة: ${emotion.intensity}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 10),
                    ...List.generate(5, (i) {
                      return Icon(
                        i < emotion.intensity ? Icons.star : Icons.star_border,
                        color: _getIntensityColor(emotion.intensity),
                        size: 16,
                      );
                    }),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              Icons.chevron_left,
              color: AppColors.accent,
              size: 30,
            ),
          ),
        );
      },
    );
  }

  Color _getEmotionColor(EmotionType type) {
    switch (type) {
      case EmotionType.happy:
        return Colors.yellow[700]!;
      case EmotionType.sad:
        return Colors.blue[700]!;
      case EmotionType.angry:
        return Colors.red[700]!;
      case EmotionType.anxious:
        return Colors.orange[700]!;
      case EmotionType.excited:
        return Colors.pink[400]!;
      case EmotionType.calm:
        return Colors.green[500]!;
      case EmotionType.tired:
        return Colors.grey[600]!;
      case EmotionType.neutral:
        return Colors.purple[300]!;
      default:
        return AppColors.accent;
    }
  }

  String _getEmotionIcon(EmotionType type) {
    switch (type) {
      case EmotionType.happy:
        return '😊';
      case EmotionType.sad:
        return '😢';
      case EmotionType.angry:
        return '😠';
      case EmotionType.anxious:
        return '😰';
      case EmotionType.excited:
        return '🤩';
      case EmotionType.calm:
        return '😌';
      case EmotionType.tired:
        return '😴';
      case EmotionType.neutral:
        return '😐';
      default:
        return '❓';
    }
  }

  String _getEmotionName(EmotionType type) {
    switch (type) {
      case EmotionType.happy:
        return 'سعيد';
      case EmotionType.sad:
        return 'حزين';
      case EmotionType.angry:
        return 'غاضب';
      case EmotionType.anxious:
        return 'قلق';
      case EmotionType.excited:
        return 'متحمس';
      case EmotionType.calm:
        return 'هادئ';
      case EmotionType.tired:
        return 'متعب';
      case EmotionType.neutral:
        return 'محايد';
      default:
        return 'أخرى';
    }
  }

  Color _getIntensityColor(int intensity) {
    switch (intensity) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.orangeAccent;
      case 5:
        return Colors.red;
      default:
        return AppColors.accent;
    }
  }
}
