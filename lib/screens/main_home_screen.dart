import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rawah/screens/achievements_screen.dart';
import 'package:rawah/screens/chat_screen.dart';
import 'package:rawah/screens/emotions_home_screen.dart';
import 'package:rawah/screens/goal_screen.dart';
import 'package:rawah/screens/selected_values_screen.dart';
import 'package:rawah/screens/settings_screen.dart';
import 'package:rawah/screens/profile_screen.dart';
import 'package:rawah/screens/login_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/services/auth_service.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 40,
        ),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  AppColors.goldenAccent.withOpacity(0.6),
                  AppColors.accent.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final imageUrl = snapshot.data?['imageUrl'];
                    final userName = snapshot.data?['name'] ?? 'المستخدم';

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 50,
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.accent,
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl)
                                  : null,
                              backgroundColor: AppColors.accent.withOpacity(
                                0.2,
                              ),
                              child: imageUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: AppColors.accent,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'أهلًا $userName في رواح ✨',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildDrawerItem(
                        icon: Icons.person,
                        text: 'الملف الشخصي',
                        color: AppColors.accent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        ),
                      ),
                      _buildDrawerItem(
                        icon: Icons.settings,
                        text: 'الإعدادات',
                        color: AppColors.accent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        ),
                      ),
                      _buildDrawerItem(
                        icon: Icons.format_quote,
                        text: 'القيم',
                        color: AppColors.accent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SelectedValuesScreen(),
                          ),
                        ),
                      ),
                      const Divider(color: AppColors.accent, height: 30),
                      _buildDrawerItem(
                        icon: Icons.exit_to_app,
                        text: 'تسجيل الخروج',
                        color: Colors.red,
                        onTap: () => AuthService().signOut().then((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
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
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '🌟 مرحبًا بك في رواح',
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
                      MaterialPageRoute(builder: (_) => const GoalsScreen()),
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
                    color: AppColors.accent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatScreen()),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
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
