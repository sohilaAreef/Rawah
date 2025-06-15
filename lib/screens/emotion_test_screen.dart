import 'package:flutter/material.dart';
import 'package:rawah/screens/emotions_suggestions_screen.dart';
import 'package:rawah/utils/app_colors.dart';

class EmotionTestScreen extends StatefulWidget {
  final String emotionTitle;
  const EmotionTestScreen({super.key, required this.emotionTitle});

  @override
  State<EmotionTestScreen> createState() => _EmotionTestScreenState();
}

class _EmotionTestScreenState extends State<EmotionTestScreen> {
  int _currentQuestionIndex = 0;
  int _totalScore = 0;
  bool _showResults = false;
  bool _hasEmotion = false;

  final Map<String, List<String>> _questions = {
    "الحزن": [
      "هل تشعر بالحزن معظم الوقت؟",
      "هل فقدت الاهتمام بالأنشطة التي كنت تستمتع بها؟",
      "هل تواجه صعوبة في النوم أو النوم أكثر من المعتاد؟"
    ],
    "القلق": [
      "هل تشعر بالتوتر أو القلق معظم الوقت؟",
      "هل تواجه صعوبة في السيطرة على مخاوفك؟",
      "هل تشعر بالرعب أو الذعر دون سبب واضح؟"
    ],
    "الغضب": [
      "هل تشعر بالغضب بسرعة؟",
      "هل تفقد أعصابك مع الآخرين؟",
      "هل تشعر بالاستياء والمرارة في علاقاتك؟"
    ],
  };

  @override
  Widget build(BuildContext context) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("اختبار ${widget.emotionTitle}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _showResults
          ? _buildResultScreen()
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _questions[widget.emotionTitle]!.length,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  
                  SizedBox(height: 20),
                  
                  
                  Text(
                    "السؤال ${_currentQuestionIndex + 1}/${_questions[widget.emotionTitle]!.length}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  
                  SizedBox(height: 25),
                  
                  
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          _questions[widget.emotionTitle]![_currentQuestionIndex],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 1.4
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  
                  Expanded(
                    child: _buildAnswerButton(),
                  ),
                ],
              ),
            ),
    ),
  );
}
 Widget _buildAnswerButton() {
  // تعريف بيانات الأزرار مع خصائص مخصصة لكل منها
  final List<Map<String, dynamic>> answerButtons = [
    {
      "text": "نعم بشدة",
      "score": 3,
      "color": Colors.red[700]!,
      "icon": Icons.sentiment_very_dissatisfied,
      "shadow": BoxShadow(
        color: Colors.red.withOpacity(0.4),
        blurRadius: 8,
        spreadRadius: 2,
        offset: Offset(0, 4),
      )
    },
    {
      "text": "نعم أحياناً",
      "score": 2,
      "color": Colors.orange[700]!,
      "icon": Icons.sentiment_dissatisfied,
      "shadow": BoxShadow(
        color: Colors.orange.withOpacity(0.4),
        blurRadius: 6,
        spreadRadius: 1,
        offset: Offset(0, 3),
      )
    },
    {
      "text": "قليلا",
      "score": 1,
      "color": Colors.amber[700]!,
      "icon": Icons.sentiment_neutral,
      "shadow": BoxShadow(
        color: Colors.amber.withOpacity(0.4),
        blurRadius: 4,
        spreadRadius: 1,
        offset: Offset(0, 2),
      )
    },
    {
      "text": "لا أبداً",
      "score": 0,
      "color": Colors.green[700]!,
      "icon": Icons.sentiment_very_satisfied,
      "shadow": BoxShadow(
        color: Colors.green.withOpacity(0.4),
        blurRadius: 4,
        spreadRadius: 1,
        offset: Offset(0, 2),
      )
    },
  ];

  return Column(
    children: answerButtons.map((button) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: ElevatedButton(
          onPressed: () => _answerQuestion(button["score"]),
          style: ElevatedButton.styleFrom(
            backgroundColor: button["color"],
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shadowColor: Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [button["shadow"]],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(button["icon"], size: 30),
                SizedBox(width: 12),
                Text(
                  button["text"],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        )
      );  
    }).toList(),
  );
}
  void _answerQuestion(int score){
    setState(() {
      _totalScore += score;
      _currentQuestionIndex++;

      if(_currentQuestionIndex >= _questions[widget.emotionTitle]!.length)
      {
        _showResults = true;
        _hasEmotion = _totalScore >= 6;
      }

    });
  }
 Widget _buildResultScreen() {
  return Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة تعبيرية حسب النتيجة
            Icon(
              _hasEmotion ? Icons.sentiment_very_dissatisfied : Icons.sentiment_very_satisfied,
              size: 80,
              color: _hasEmotion ? Colors.orange : AppColors.accent,
            ),
            
            const SizedBox(height: 25),
            
            // نص النتيجة مع تصميم مميز
            Text(
              _hasEmotion 
                  ? "يبدو أنك تمر بتجربة ${widget.emotionTitle}"
                  : "رائع! حالتك جيدة تجاه ${widget.emotionTitle}",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _hasEmotion ? Colors.orange : AppColors.accent,
                height: 1.4
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 15),
            
            // نص توجيهي إضافي
            Text(
              _hasEmotion 
                  ? "لا تقلق، لدينا اقتراحات لمساعدتك"
                  : "استمر في الحفاظ على صحتك النفسية",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // بطاقة عرض الدرجة
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),),
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "نتيجة الاختبار",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$_totalScore/${_questions[widget.emotionTitle]!.length * 3}",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: _totalScore / (_questions[widget.emotionTitle]!.length * 3),
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _hasEmotion ? Colors.orange : AppColors.accent
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            
            if (_hasEmotion)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Suggestions()),
                  );
                },
                icon: Icon(Icons.lightbulb_outline, size: 26),
                label: Text(
                  "عرض الاقتراحات المساعدة",
                  style: TextStyle(fontSize: 22),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
            
            // زر العودة
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, size: 22),
              label: Text(
                "العودة إلى قائمة المشاعر",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}