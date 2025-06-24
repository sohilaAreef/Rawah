import 'package:flutter/material.dart';
import 'package:rawah/models/daily_emotion.dart';
import 'package:rawah/utils/app_colors.dart';

class EmotionSelector extends StatelessWidget {
  final EmotionType? selectedEmotion;
  final int selectedIntensity;
  final ValueChanged<EmotionType> onEmotionSelected;
  final ValueChanged<int> onIntensitySelected;

  const EmotionSelector({
    super.key,
    required this.selectedEmotion,
    required this.selectedIntensity,
    required this.onEmotionSelected,
    required this.onIntensitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final Map<EmotionType, String> emotionIcons = {
      EmotionType.happy: '😊 سعيد',
      EmotionType.sad: '😢 حزين',
      EmotionType.angry: '😠 غاضب',
      EmotionType.anxious: '😰 قلق',
      EmotionType.excited: '🤩 متحمس',
      EmotionType.calm: '😌 هادئ',
      EmotionType.tired: '😴 متعب',
      EmotionType.neutral: '😐 محايد',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'اختر نوع الشعور:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 10),

        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: emotionIcons.entries.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final entry = emotionIcons.entries.elementAt(index);
              final isSelected = selectedEmotion == entry.key;
              return ChoiceChip(
                label: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onEmotionSelected(entry.key);
                  }
                },
                selectedColor: AppColors.accent,
                backgroundColor: Colors.grey[200],
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                showCheckmark: false,
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'شدة الشعور:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.sentiment_very_dissatisfied,
                color: Colors.red,
                size: 28,
              ),
              Expanded(
                child: Slider(
                  value: selectedIntensity.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: selectedIntensity.toString(),
                  activeColor: _getIntensityColor(selectedIntensity),
                  inactiveColor: Colors.grey[300],
                  onChanged: (value) {
                    onIntensitySelected(value.toInt());
                  },
                ),
              ),
              Icon(
                Icons.sentiment_very_satisfied,
                color: Colors.green,
                size: 28,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('خفيفة', style: TextStyle(fontSize: 14)),
              Text('متوسطة', style: TextStyle(fontSize: 14)),
              Text('قوية', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
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
