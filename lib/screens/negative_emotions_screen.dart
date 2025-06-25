import 'package:flutter/material.dart';
import 'package:rawah/screens/emotion_test_screen.dart';
import 'package:rawah/utils/app_colors.dart';

class NegativeEmotionsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> emotions = [
    {
      "title": "الحزن",
      "icon": Icons.sentiment_very_dissatisfied,
      "color": Colors.blue,
      "description":
          "شعور عميق بالأسى والضيق النفسي المصحوب بالبكاء وفقدان الاهتمام",
    },
    {
      "title": "القلق",
      "icon": Icons.psychology,
      "color": Colors.orange,
      "description":
          "شعور مزعج بالخوف والتوتر يصاحبه أعراض جسدية مثل تسارع القلب",
    },
    {
      "title": "الغضب",
      "icon": Icons.mood_bad,
      "color": Colors.red,
      "description":
          "استجابة عاطفية قوية للإحباط أو الظلم، مع رغبة في التعبير عن الاستياء",
    },
  ];

  NegativeEmotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 80,
          title: const Text(
            "المشاعر السلبية",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFF5F7FA)],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "فهم مشاعرك هو أول خطوة نحو التحكم فيها",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: emotions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    return _buildEmotionCard(context, emotions[index]);
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "الاختبارات تساعدك على فهم مشاعرك بشكل أفضل",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionCard(BuildContext context, Map<String, dynamic> emotion) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EmotionTestScreen(emotionTitle: emotion["title"]),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: emotion["color"].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(emotion["icon"], size: 30, color: emotion["color"]),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emotion["title"],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      emotion["description"],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.accent,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
