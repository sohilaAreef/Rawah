import 'package:flutter/material.dart';
import 'package:rawah/models/daily_emotion.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/screens/chat_screen.dart';

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
    final Map<EmotionType, String> emojiMap = {
      EmotionType.happy: '😊',
      EmotionType.sad: '😢',
      EmotionType.angry: '😠',
      EmotionType.anxious: '😰',
      EmotionType.excited: '🤩',
      EmotionType.calm: '😌',
      EmotionType.tired: '😴',
      EmotionType.neutral: '😐',
    };

    final Map<EmotionType, String> labelMap = {
      EmotionType.happy: 'سعيد',
      EmotionType.sad: 'حزين',
      EmotionType.angry: 'غاضب',
      EmotionType.anxious: 'قلق',
      EmotionType.excited: 'متحمس',
      EmotionType.calm: 'هادئ',
      EmotionType.tired: 'متعب',
      EmotionType.neutral: 'محايد',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'اختر نوع الشعور:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8DC), // لون أصفر فاتح وجميل
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: emojiMap.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final type = emojiMap.keys.elementAt(index);
                final emoji = emojiMap[type]!;
                final label = labelMap[type]!;
                final isSelected = selectedEmotion == type;

                return GestureDetector(
                  onTap: () => onEmotionSelected(type),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.accent : Colors.white,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.accent.withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.accent
                              : Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 24),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'مرّر الوجوه لاختيار شعورك المناسب 😊',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'شدة الشعور:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.sentiment_dissatisfied, color: Colors.red),
              Expanded(
                child: Slider(
                  value: selectedIntensity.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: selectedIntensity.toString(),
                  activeColor: _getIntensityColor(selectedIntensity),
                  inactiveColor: Colors.grey[300],
                  onChanged: (value) => onIntensitySelected(value.toInt()),
                ),
              ),
              const Icon(Icons.sentiment_satisfied, color: Colors.green),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('خفيفة', style: TextStyle(fontSize: 13)),
              Text('متوسطة', style: TextStyle(fontSize: 13)),
              Text('قوية', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                'مش لاقي شعورك؟ المشاعر أعقد من كلمة!',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  'الدردشة مع رواح',
                  style: TextStyle(color: Colors.white),
                ),
              ),
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
