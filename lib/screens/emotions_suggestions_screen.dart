import 'package:flutter/material.dart';
import 'package:rawah/utils/app_colors.dart';

class Suggestions extends StatelessWidget {
  final List<Map<String, String>> Suggest = [
    {
      "title": "خذ نزهة",
      "description": "النشاط البدني يمكن أن يساعد في تقليل التوتر وتحسين المزاج.",
      "image": "assets/images/take (1).png"
    },
    {
      "title": "مارس الامتنان",
      "description": "أخذ وقت لتقدير الأشياء الجيدة في الحياة يمكن أن يحول تركيزك من السلبي إلى الإيجابي.",
      "image": "assets/images/gra (1).png"
    },
    {
      "title": "تواصل مع أحبائك",
      "description": "التحدث مع الأصدقاء والعائلة يمكن أن يوفر الراحة والدعم في الأوقات الصعبة.",
      "image": "assets/images/fam (1).png"
    }
  ];

  Suggestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          title: Text("اقتراحات", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: false,
        ),
        body: ListView.builder(
          itemCount: Suggest.length,
          itemBuilder: (context, index) {
            final suggest = Suggest[index];
            return Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Column(
                children: [
                  Image.asset(
                    suggest["image"]!,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity, 
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        
                        Text(
                          suggest["title"]!,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        Text(
                          suggest["description"]!,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        SizedBox(height: 15),
                        // الزر
                        Align(
                          alignment: Alignment.centerLeft, 
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                
                              ),
                            ),
                            child: Text(
                              "تم",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                              
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
