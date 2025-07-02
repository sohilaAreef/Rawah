import 'package:flutter/material.dart';
import 'package:rawah/screens/home_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/utils/app_sounds.dart';

class Suggestions extends StatelessWidget {
  final String emotionTitle;

  Suggestions({super.key, required this.emotionTitle});

  final Map<String, List<Map<String, dynamic>>> _suggestions = {
    "الحزن": [
      {
        "title": "التعبير عن المشاعر",
        "description":
            "اكتب مشاعرك في دفتر يوميات، التحدث مع صديق مقرب يساعد في التخفيف من الحزن.",
        "icon": Icons.edit,
        "color": Colors.blue,
      },
      {
        "title": "النشاط البدني",
        "description":
            "مارس المشي أو اليوجا لمدة 30 دقيقة يومياً، الرياضة تفرز هرمونات تحسن المزاج.",
        "icon": Icons.directions_walk,
        "color": Colors.green,
      },
      {
        "title": "الروتين الصحي",
        "description":
            "احرص على النوم 8 ساعات وتناول غذاء متوازن، الصحة الجسدية تؤثر إيجابياً على النفسية.",
        "icon": Icons.favorite,
        "color": Colors.red,
      },
    ],
    "القلق": [
      {
        "title": "تمارين التنفس",
        "description":
            "تنفس بعمق لمدة 4 ثوانٍ، احبس النفس 4 ثوانٍ، أطلق الزفير في 8 ثوانٍ. كرر 5 مرات.",
        "icon": Icons.air,
        "color": Colors.teal,
      },
      {
        "title": "التأمل اليومي",
        "description":
            "خصص 10 دقائق صباحاً للجلوس في مكان هادئ والتركيز على الحاضر.",
        "icon": Icons.self_improvement,
        "color": Colors.purple,
      },
      {
        "title": "تحديد المخاوف",
        "description":
            "اكتب مخاوفك وحلل مدى واقعيتها، وضع خططاً بديلة لكل سيناريو.",
        "icon": Icons.list,
        "color": Colors.orange,
      },
    ],
    "الغضب": [
      {
        "title": "العد التنازلي",
        "description":
            "عند الشعور بالغضب، ابدأ العد التنازلي من 20 قبل التحدث أو التصرف.",
        "icon": Icons.timer,
        "color": Colors.red,
      },
      {
        "title": "تأجيل الرد",
        "description":
            "أخبر الطرف الآخر أنك تحتاج لوقت للتفكير وارجع للموضوع لاحقاً.",
        "icon": Icons.pause_circle,
        "color": Colors.blueGrey,
      },
      {
        "title": "تحويل الطاقة",
        "description":
            "استخدم الطاقة السلبية في نشاط بدني كالمشي السريع أو تمارين القوة.",
        "icon": Icons.fitness_center,
        "color": Colors.orange,
      },
    ],
    "الخوف": [
      {
        "title": "المواجهة التدريجية",
        "description":
            "ضع قائمة بمواقف مخيفة مرتبة حسب الشدة وواجهها واحدة تلو الأخرى.",
        "icon": Icons.ads_click,
        "color": Colors.purple,
      },
      {
        "title": "التعليم والمعرفة",
        "description":
            "اقرأ عن موضوع خوفك، المعرفة تقلل من الغموض وتزيد الشعور بالسيطرة.",
        "icon": Icons.menu_book,
        "color": Colors.indigo,
      },
      {
        "title": "التخيل الإيجابي",
        "description":
            "تخيل نفسك تتعامل بنجاح مع الموقف المخيف 5 دقائق يومياً.",
        "icon": Icons.lightbulb,
        "color": Colors.lightBlue,
      },
    ],
    "الوحدة": [
      {
        "title": "الأنشطة الجماعية",
        "description":
            "انضم لنادي أو مجموعة تهتم بهواياتك، الاهتمامات المشتركة تبني جسوراً.",
        "icon": Icons.group,
        "color": Colors.green,
      },
      {
        "title": "التطوع",
        "description":
            "ساعد الآخرين، العمل التطوعي يعزز الانتماء ويخلق علاقات هادفة.",
        "icon": Icons.volunteer_activism,
        "color": Colors.red,
      },
      {
        "title": "إعادة الاتصال",
        "description":
            "راسل صديقاً قديماً أو قريباً، ابدأ بمحادثة قصيرة دون ضغوط.",
        "icon": Icons.connect_without_contact,
        "color": Colors.blue,
      },
    ],
    "الإحباط": [
      {
        "title": "تقسيم الأهداف",
        "description":
            "جزّئ أهدافك الكبيرة إلى خطوات صغيرة قابلة للتحقيق واحتفل بكل إنجاز.",
        "icon": Icons.flag,
        "color": Colors.blue,
      },
      {
        "title": "مراجعة الإنجازات",
        "description":
            "اكتب قائمة بإنجازاتك السابقة مهما كانت صغيرة، ذكّر نفسك بقدراتك.",
        "icon": Icons.star,
        "color": Colors.amber,
      },
      {
        "title": "تعديل التوقعات",
        "description":
            "ركز على الجهد بدلاً من النتيجة، وتقبل أن الكمال غير ممكن.",
        "icon": Icons.auto_awesome,
        "color": Colors.purple,
      },
    ],
    "الذنب": [
      {
        "title": "التسامح مع الذات",
        "description":
            "تعلم أن تسامح نفسك على الأخطاء الماضية وتذكر أن الإنسان معرض للخطأ.",
        "icon": Icons.self_improvement,
        "color": Colors.blue,
      },
      {
        "title": "تعلم من التجربة",
        "description":
            "حول الشعور بالذنب إلى فرصة للتعلم والنمو. اسأل نفسك: ماذا يمكن أن أفعل بشكل مختلف في المستقبل؟",
        "icon": Icons.school,
        "color": Colors.green,
      },
      {
        "title": "شارك مشاعرك",
        "description":
            "تحدث مع شخص تثق به عن مشاعرك بالذنب. مشاركة المشاعر تقلل من حدتها.",
        "icon": Icons.share,
        "color": Colors.purple,
      },
    ],
    "الغيرة": [
      {
        "title": "التركيز على الذات",
        "description":
            "ركز على تطوير نفسك بدلاً من مقارنة نفسك بالآخرين. ضع أهدافاً شخصية واعمل على تحقيقها.",
        "icon": Icons.person,
        "color": Colors.amber,
      },
      {
        "title": "الامتنان",
        "description":
            "اكتب قائمة بالأشياء التي تمتلكها وتشعر بالامتنان لها. الامتنان يقلل من مشاعر الغيرة.",
        "icon": Icons.thumb_up,
        "color": Colors.lightBlue,
      },
      {
        "title": "تحويل الغيرة إلى إلهام",
        "description":
            "انظر إلى نجاح الآخرين كمصدر للإلهام. اسأل نفسك: ماذا يمكن أن أتعلم منهم؟",
        "icon": Icons.lightbulb_outline,
        "color": Colors.green,
      },
    ],
    "اليأس": [
      {
        "title": "التركيز على الخطوة الصغيرة",
        "description":
            "ركز على خطوة صغيرة يمكنك اتخاذها الآن. لا تفكر في الصورة الكبيرة التي قد تثبط عزيمتك.",
        "icon": Icons.directions_walk,
        "color": Colors.blue,
      },
      {
        "title": "تذكر النجاحات السابقة",
        "description":
            "فكر في التحديات التي تغلبت عليها في الماضي. هذا يذكرك بقدرتك على تجاوز الصعاب.",
        "icon": Icons.history,
        "color": Colors.orange,
      },
      {
        "title": "طلب الدعم",
        "description":
            "تواصل مع أشخاص يقدمون الدعم. مشاركة مشاعرك مع من يفهمك يخفف من اليأس.",
        "icon": Icons.support,
        "color": Colors.red,
      },
    ],
    "العار": [
      {
        "title": "التعاطف مع الذات",
        "description":
            "عامل نفسك بلطف كما تعامل صديقاً عزيزاً. قل لنفسك: أنا إنسان وأخطئ وهذا طبيعي.",
        "icon": Icons.favorite,
        "color": Colors.pink,
      },
      {
        "title": "مواجهة الأفكار السلبية",
        "description":
            "تحدى الأفكار التي تسبب العار. اسأل نفسك: هل هذا صحيح؟ هل هناك دليل؟",
        "icon": Icons.psychology,
        "color": Colors.deepPurple,
      },
      {
        "title": "تقبل الذات",
        "description":
            "تعلم تقبل نفسك بكل عيوبك. الكمال لله وحده، وأنت كإنسان لديك نقاط قوة وضعف.",
        "icon": Icons.handshake,
        "color": Colors.teal,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final emotionSuggestions = _suggestions[emotionTitle] ?? [];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "اقتراحات لـ $emotionTitle",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(initialIndex: 4),
                ),
                (route) => false,
              );
            },
          ),
        ),

        backgroundColor: const Color(0xFFF9F9F9),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: emotionSuggestions.length,
          itemBuilder: (context, index) {
            final suggest = emotionSuggestions[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: suggest["color"].withOpacity(0.15),
                        child: Icon(
                          suggest["icon"],
                          size: 28,
                          color: suggest["color"],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          suggest["title"],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    suggest["description"],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        AppSounds.playSubGoalComplete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "👏أحسنت! تطبيق الاقتراح خطوة جميلة ",
                              textDirection: TextDirection.rtl,
                            ),
                            backgroundColor: AppColors.accent,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("تم"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
