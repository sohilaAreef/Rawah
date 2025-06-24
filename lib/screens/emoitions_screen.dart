
import 'package:flutter/material.dart';
import 'package:rawah/screens/emotion_test_screen.dart';
import 'package:rawah/utils/app_colors.dart';

class EmotionsScreen extends StatelessWidget {
  final List<Map<String, String>> emotions = [
    {
      "title": "الحزن",
      "image": "assets/images/sad (1).png"
    },
    {
      "title": "القلق",
      "image": "assets/images/Depth 3, Frame 0.png"
    },
    {
      "title": "الغضب",
      "image": "assets/images/ang (1).png"
    }
  ];

  EmotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          toolbarHeight: 80,
          title: Text("المشاعر السلبية", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        body: ListView.builder(
          itemCount: emotions.length,
          itemBuilder: (context, index) {
            final emotion = emotions[index];
            return Card(
              margin: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      emotion["image"]!,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            emotion["title"]!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmotionTestScreen(emotionTitle: emotion["title"]!),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: Text(
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
