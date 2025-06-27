import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rawah/screens/achievements_screen.dart';
import 'package:rawah/screens/chat_screen.dart';
import 'package:rawah/screens/emotions_home_screen.dart';
import 'package:rawah/screens/goal_screen.dart';
import 'package:rawah/screens/login_screen.dart';
import 'package:rawah/screens/profile_screen.dart';
import 'package:rawah/screens/selected_values_screen.dart';
import 'package:rawah/screens/settings_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  String firstName = '';
  bool isLoading = true;

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
                            color: Colors.blue,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EmotionsHomeScreen(),
                              ),
                            ),
                          ),
                          _buildCard(
                            context,
                            title: 'القيم',
                            icon: Icons.format_quote,
                            color: Colors.green,
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
                            color: Colors.orange,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AchievementsScreen(),
                              ),
                            ),
                          ),
                          _buildCard(
                            context,
                            title: 'الأهداف',
                            icon: Icons.flag,
                            color: Colors.purple,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GoalsScreen(),
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 30),

                        // Section 3: الدعم النفسي
                        _buildSectionTitle(
                          'الدعم النفسي',
                          'تحدث إلى رواح، صديقك الداعم دائمًا',
                        ),
                        _buildGrid(context, [
                          _buildCard(
                            context,
                            title: 'محادثة مع رواح',
                            icon: Icons.chat,
                            color: AppColors.accent,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChatScreen(),
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
              fontSize: 20,
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
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 72) / 2,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.bold,
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
