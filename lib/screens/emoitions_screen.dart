import 'package:flutter/material.dart';
import 'package:rawah/screens/emotion_test_screen.dart';
import 'package:rawah/utils/app_colors.dart';

class EmotionsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> emotions = [
    {"title": "الحزن", "icon": Icons.mood_bad, "color": Colors.blueGrey},
    {"title": "القلق", "icon": Icons.error_outline, "color": Colors.orange},
    {"title": "الغضب", "icon": Icons.whatshot, "color": Colors.red},
    {
      "title": "الخوف",
      "icon": Icons.warning_amber_rounded,
      "color": Colors.deepPurple,
    },
    {"title": "الوحدة", "icon": Icons.person_outline, "color": Colors.grey},
    {
      "title": "الإحباط",
      "icon": Icons.sentiment_neutral,
      "color": Colors.brown,
    },
  ];

  EmotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("عدد المشاعر: ${emotions.length}");

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          toolbarHeight: 80,
          title: const Text(
            "المشاعر السلبية",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: emotions.length,
          itemBuilder: (context, index) {
            final emotion = emotions[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: emotion["color"]!.withOpacity(0.2),
                      radius: 40,
                      child: Icon(
                        emotion["icon"],
                        size: 32,
                        color: emotion["color"],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        emotion["title"],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmotionTestScreen(
                              emotionTitle: emotion["title"]!,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "بدء الاختبار",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
