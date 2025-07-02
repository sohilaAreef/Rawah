import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rawah/screens/achievements_screen.dart';
import 'package:rawah/screens/chat_screen.dart';
import 'package:rawah/screens/emotions_home_screen.dart';
import 'package:rawah/screens/goal_screen.dart';
import 'package:rawah/screens/home_screen.dart';
import 'package:rawah/screens/login_screen.dart';
import 'package:rawah/screens/profile_screen.dart';
import 'package:rawah/screens/selected_values_screen.dart';
import 'package:rawah/screens/settings_screen.dart';
import 'package:rawah/services/notification_service.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  String firstName = '';
  bool isLoading = true;
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationService service = NotificationService();

  @override
  void initState() {
    super.initState();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          firstName = data['firstName'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.accent),
          ),
          drawer: Drawer(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 60, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 40),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: const Icon(
                        Icons.person,
                        color: AppColors.accent,
                      ),
                      title: const Text(
                        'الملف الشخصي',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),

                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: const Icon(
                        Icons.settings,
                        color: AppColors.accent,
                      ),
                      title: const Text(
                        'الإعدادات',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: const Icon(
                        Icons.info_outline,
                        color: AppColors.accent,
                      ),
                      title: const Text(
                        'عن التطبيق',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              backgroundColor: const Color.fromARGB(
                                255,
                                255,
                                253,
                                226,
                              ),
                              title: const Text(
                                'عن التطبيق',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'رواح هو رفيقك في رحلة النمو الشخصي والتوازن النفسي. يساعدك على:\n',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    RichText(
                                      textAlign: TextAlign.right,
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '• ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'تحديد أهدافك: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                'تنظيم أهدافك والسعي لتحقيقها بخطوات واضحة.\n',
                                          ),
                                          TextSpan(
                                            text: '• ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'تسجيل الإنجازات: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                'تذكر نجاحاتك الصغيرة والكبيرة لتعزيز ثقتك بنفسك.\n',
                                          ),
                                          TextSpan(
                                            text: '• ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'الامتنان: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                'تدوين الأشياء التي تشعر بالامتنان لها لزيادة شعورك بالسعادة والرضا.\n',
                                          ),
                                          TextSpan(
                                            text: '• ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'تتبع المشاعر اليومية: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                'فهم مشاعرك بشكل أفضل والتعامل معها بطريقة صحية.\n',
                                          ),
                                          TextSpan(
                                            text: '• ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'اختبار المشاعر السلبية: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                'تحليل مشاعرك السلبية وكيفية التعامل معها.\n',
                                          ),
                                          TextSpan(
                                            text: '• ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'تحديد القيم الشخصية: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                'اكتشاف قيمك الأساسية ووضع خطوات عملية لتطبيقها في حياتك.\n\n',
                                          ),
                                          TextSpan(
                                            text:
                                                'باختصار، رواح هو مساحة آمنة لك للاعتناء بنفسك وتحقيق أفضل نسخة منك.',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              actions: [
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.goldenAccent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'حسناً',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.mail_outline,
                        color: AppColors.accent,
                      ),
                      title: const Text(
                        'تواصل معنا',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      collapsedIconColor: AppColors.accent,
                      iconColor: AppColors.accent,
                      childrenPadding: const EdgeInsets.only(
                        right: 32,
                        bottom: 8,
                      ),
                      children: [
                        ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.person,
                            color: AppColors.accent,
                          ),
                          title: const Text(
                            'تواصل مع المطور',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: AppColors.accent,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          onTap: () {
                            _launchEmail('sohilaarif01@gmail.com');
                          },
                        ),
                        ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.group,
                            color: AppColors.accent,
                          ),
                          title: const Text(
                            'تواصل مع فريق رواح',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: AppColors.accent,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          onTap: () {
                            _launchEmail('rawahteem@gmail.com');
                          },
                        ),
                      ],
                    ),

                    const Divider(height: 40, color: Colors.grey),

                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      onTap: () async {
                        Navigator.pop(context);

                        await FirebaseAuth.instance.signOut();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          backgroundColor: Colors.white,
          body: SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  firstName.isNotEmpty
                                      ? '🌟 مرحبًا بك $firstName في رواح'
                                      : '🌟 مرحبًا بك في رواح',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'اختر ما يناسبك حسب حالتك النفسية✨ ',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        _buildSectionTitle(
                          'الرفاه النفسي',
                          'ساعد نفسك على تخطي المشاعر السلبية وتعزيز الإيجابية',
                        ),
                        _buildGrid(context, [
                          _buildCard(
                            context,
                            title: 'المشاعر',
                            icon: Icons.emoji_emotions,
                            gradientColors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent,
                            ],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const HomeScreen(initialIndex: 2),
                              ),
                            ),
                          ),
                          _buildCard(
                            context,
                            title: 'القيم',
                            icon: Icons.lightbulb,
                            gradientColors: [Colors.green, Colors.teal],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SelectedValuesScreen(),
                              ),
                            ),
                          ),
                        ]),

                        const SizedBox(height: 30),

                        _buildSectionTitle(
                          'الإنجاز والشكر',
                          'سجّل إنجازاتك واحتفل بنفسك',
                        ),
                        _buildGrid(context, [
                          _buildCard(
                            context,
                            title: 'الإنجازات',
                            icon: Icons.emoji_events,
                            gradientColors: [
                              Colors.deepOrange,
                              Colors.orangeAccent,
                            ],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const HomeScreen(initialIndex: 1),
                              ),
                            ),
                          ),
                          _buildCard(
                            context,
                            title: 'الأهداف',
                            icon: Icons.flag,
                            gradientColors: [
                              Colors.deepPurple,
                              Colors.purpleAccent,
                            ],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const HomeScreen(initialIndex: 3),
                              ),
                            ),
                          ),
                        ]),

                        const SizedBox(height: 30),

                        _buildSectionTitle(
                          'الدعم النفسي',
                          'تحدث إلى رواح، صديقك الداعم دائمًا',
                        ),
                        _buildGrid(context, [
                          _buildCard(
                            context,
                            title: 'محادثة مع رواح',
                            icon: Icons.chat,
                            gradientColors: [AppColors.accent, Colors.teal],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const HomeScreen(initialIndex: 0),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تعذر فتح البريد الإلكتروني')));
    }
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            subtitle,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<Widget> children) {
    if (children.length == 1) {
      return Align(alignment: Alignment.centerRight, child: children.first);
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.end,
      children: children,
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 72) / 2,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: gradientColors.first, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
