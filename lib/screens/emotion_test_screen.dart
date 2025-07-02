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
      "هل تواجه صعوبة في النوم أو النوم أكثر من المعتاد؟",
      "هل تشعر بالتعب والإرهاق باستمرار؟",
      "هل تشعر بالذنب أو انعدام القيمة؟",
      "هل تواجه صعوبة في التركيز أو اتخاذ القرارات؟",
      "هل تفكر في الموت أو الانتحار؟",
    ],
    "القلق": [
      "هل تشعر بالتوتر أو القلق معظم الوقت؟",
      "هل تواجه صعوبة في السيطرة على مخاوفك؟",
      "هل تشعر بالرعب أو الذعر دون سبب واضح؟",
      "هل تعاني من اضطرابات في النوم بسبب القلق؟",
      "هل تشعر بالتوتر العضلي أو الصداع المتكرر؟",
      "هل تتجنب المواقف التي قد تسبب لك القلق؟",
      "هل تشعر بالخوف الشديد من أشياء محددة؟",
    ],
    "الغضب": [
      "هل تشعر بالغضب بسرعة؟",
      "هل تفقد أعصابك مع الآخرين؟",
      "هل تشعر بالاستياء والمرارة في علاقاتك؟",
      "هل تعبر عن غضبك بشكل عدواني أو عنيف؟",
      "هل تشعر بالندم بعد نوبات الغضب؟",
      "هل يؤثر غضبك على علاقاتك الشخصية؟",
      "هل تجد صعوبة في التسامح أو نسيان الإساءات؟",
    ],
    "الخوف": [
      "هل تشعر بالخوف في مواقف غير خطيرة؟",
      "هل تتجنب أماكن أو أنشطة بسبب خوفك؟",
      "هل تعاني من نوبات هلع أو خوف شديد؟",
      "هل تشعر بالخوف من أشياء محددة (حيوانات، مرتفعات، إلخ)؟",
      "هل يؤثر خوفك على حياتك اليومية؟",
      "هل تشعر بالقلق المفرط من المستقبل؟",
      "هل تعاني من أعراض جسدية عند مواجهة مخاوفك؟",
    ],
    "الوحدة": [
      "هل تشعر بالعزلة رغم وجود الآخرين؟",
      "هل تشعر بأن لا أحد يفهمك؟",
      "هل تفتقد للعلاقات العميقة في حياتك؟",
      "هل تتجنب التواصل مع الآخرين؟",
      "هل تشعر بعدم الانتماء للمجموعات؟",
      "هل تعتقد أن الآخرين لا يهتمون بك؟",
      "هل تشعر بالفراغ العاطفي؟",
    ],
    "الإحباط": [
      "هل تشعر بعدم تحقيق أهدافك؟",
      "هل تشعر أن جهودك لا تؤتي ثمارها؟",
      "هل فقدت الحماس لما كنت تحبه؟",
      "هل تشعر بأن الظروف ضدك؟",
      "هل تشعر بالعجز عن تغيير وضعك؟",
      "هل فقدت الأمل في تحسين الأمور؟",
      "هل تشعر أنك لا تستحق النجاح؟",
    ],
    "الذنب": [
      "هل تشعر بالذنب تجاه أمور حدثت في الماضي؟",
      "هل تلوم نفسك على أخطاء ارتكبتها؟",
      "هل تشعر أنك لا تستحق المغفرة؟",
      "هل تتجنب مواقف معينة بسبب شعورك بالذنب؟",
      "هل يؤثر شعورك بالذنب على حياتك الحالية؟",
      "هل تعتقد أنك ارتكبت أخطاء لا يمكن إصلاحها؟",
      "هل تشعر بالذنب حتى عندما لا تكون مسؤولاً عن الموقف؟",
    ],
    "الغيرة": [
      "هل تشعر بعدم الرضا عندما ترى نجاح الآخرين؟",
      "هل تقارن نفسك بالآخرين باستمرار؟",
      "هل تشعر بالاستياء من الأشخاص الذين يملكون ما تريده؟",
      "هل تؤثر غيرتك على علاقاتك مع الآخرين؟",
      "هل تخفي مشاعر الغيرة عن الآخرين؟",
      "هل تبالغ في رد فعلك عندما تتعرض للمقارنة؟",
      "هل تعتقد أن الغيرة تحفزك أم تعيقك؟",
    ],
    "اليأس": [
      "هل تشعر أن الأمور لن تتحسن أبداً؟",
      "هل فقدت الأمل في تحقيق أهدافك؟",
      "هل تشعر أنك لا تملك الطاقة لمحاولة التغيير؟",
      "هل تعتقد أن الحياة لا معنى لها؟",
      "هل تشعر بالعجز عن تغيير ظروفك؟",
      "هل تخبر نفسك بأنه لا فائدة من المحاولة؟",
      "هل تؤثر مشاعر اليأس على رغبتك في التواصل مع الآخرين؟",
    ],
    "العار": [
      "هل تشعر بالخجل من نفسك أو من ماضيك؟",
      "هل تخشى أن يكتشف الآخرون عيوبك؟",
      "هل تتجنب المواقف الاجتماعية خوفاً من الإحراج؟",
      "هل تشعر أنك لا تستحق الاحترام؟",
      "هل تؤثر مشاعر العار على ثقتك بنفسك؟",
      "هل تعتقد أن أخطاءك تعكس قيمتك كإنسان؟",
      "هل تشعر بالعار حتى عندما لا تكون مسؤولاً عن الموقف؟",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "اختبار ${widget.emotionTitle}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
                      value:
                          (_currentQuestionIndex + 1) /
                          _questions[widget.emotionTitle]!.length,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accent,
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "السؤال ${_currentQuestionIndex + 1}/${_questions[widget.emotionTitle]!.length}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            _questions[widget
                                .emotionTitle]![_currentQuestionIndex],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(child: _buildAnswerButton()),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildAnswerButton() {
    final List<Map<String, dynamic>> answerButtons = [
      {
        "text": "نعم بشدة",
        "score": 3,
        "color": Colors.red[700]!,
        "icon": Icons.sentiment_very_dissatisfied,
      },
      {
        "text": "نعم أحياناً",
        "score": 2,
        "color": Colors.orange[700]!,
        "icon": Icons.sentiment_dissatisfied,
      },
      {
        "text": "قليلاً",
        "score": 1,
        "color": Colors.blue[700]!,
        "icon": Icons.sentiment_neutral,
      },
      {
        "text": "لا أبداً",
        "score": 0,
        "color": Colors.green[700]!,
        "icon": Icons.sentiment_very_satisfied,
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
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  button["text"],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(button["icon"], size: 30),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _answerQuestion(int score) {
    setState(() {
      _totalScore += score;
      _currentQuestionIndex++;

      if (_currentQuestionIndex >= _questions[widget.emotionTitle]!.length) {
        _showResults = true;
        _hasEmotion =
            _totalScore >= (_questions[widget.emotionTitle]!.length * 1.5);
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
              Icon(
                _hasEmotion
                    ? Icons.sentiment_very_dissatisfied
                    : Icons.sentiment_very_satisfied,
                size: 80,
                color: _hasEmotion ? Colors.orange : AppColors.accent,
              ),
              const SizedBox(height: 25),
              Text(
                _hasEmotion
                    ? "يبدو أنك تمر بتجربة ${widget.emotionTitle}"
                    : "رائع! حالتك جيدة تجاه ${widget.emotionTitle}",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _hasEmotion ? Colors.orange : AppColors.accent,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                _hasEmotion
                    ? "لا تقلق، لدينا اقتراحات لمساعدتك"
                    : "استمر في الحفاظ على صحتك النفسية",
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
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
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value:
                            _totalScore /
                            (_questions[widget.emotionTitle]!.length * 3),
                        minHeight: 10,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _hasEmotion ? Colors.orange : AppColors.accent,
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
                      MaterialPageRoute(
                        builder: (context) =>
                            Suggestions(emotionTitle: widget.emotionTitle),
                      ),
                    );
                  },
                  icon: const Icon(Icons.lightbulb_outline, size: 26),
                  label: const Text(
                    "عرض الاقتراحات المساعدة",
                    style: TextStyle(fontSize: 22),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 22),
                label: Text(
                  "العودة إلى قائمة المشاعر",
                  style: TextStyle(fontSize: 18, color: AppColors.accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
