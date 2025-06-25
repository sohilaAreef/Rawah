import 'package:flutter/material.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/intro1.png',
      'title': 'مرحبًا بك في رواح',
      'heading': 'استكشف ذاتك وارتقِ بنفسك.',
      'description':
          'رواح يساعدك على فهم مشاعرك، تعزيز قيمك، وتحقيق التوازن في حياتك.',
    },
    {
      'image': 'assets/images/intro2.png',
      'title': 'تتبع مشاعرك وسلوكياتك',
      'heading': 'وعي أكبر بذاتك.',
      'description': 'سجّل مشاعرك يوميًا واكتشف كيف تؤثر على حياتك وسلوكياتك.',
    },
    {
      'image': 'assets/images/intro3.png',
      'title': 'ضع أهدافك وحققها',
      'heading': 'أهداف صغيرة... إنجازات كبيرة.',
      'description': 'حدّد أهدافًا قابلة للتحقيق وتابع تقدمك بخطوات بسيطة.',
    },
    {
      'image': 'assets/images/intro4.png',
      'title': 'عزز قيمك بالحياة اليومية',
      'heading': 'قوّي قيمك بالأفعال.',
      'description':
          'اختر قيمة أساسية تعيش بيها، وخلي التطبيق يساعدك تعززها يوميًا بأفعال واضحة.',
    },
  ];

  void _navigateToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 242, 242),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          onboardingData[index]['image']!,
                          height: 200,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          onboardingData[index]['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          onboardingData[index]['heading']!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppColors.accent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          onboardingData[index]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.accent
                        : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage == onboardingData.length - 1) {
                    _navigateToLogin();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  _currentPage == onboardingData.length - 1
                      ? 'ابدأ الآن'
                      : 'التالي',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
