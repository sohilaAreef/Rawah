import 'package:flutter/material.dart';
import 'package:rawah/screens/profile_screen.dart';
import 'package:rawah/screens/login_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 106, 190, 169),
          automaticallyImplyLeading: false,
          title: const Text(
            'الإعدادات',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection('الحساب'),
            _buildSettingItem(
              icon: Icons.person,
              title: 'الملف الشخصي',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
            ),
            _buildSection('المزيد'),
            _buildSettingItem(
              icon: Icons.info_outline,
              title: 'عن التطبيق',
              onTap: () => _showAboutDialog(context),
            ),
            _buildSettingItem(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              color: Colors.red,
              onTap: () => _showLogoutConfirmation(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8, right: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.accent,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.accent, size: 28),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: color ?? AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        trailing: trailing,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppColors.goldenAccent.withOpacity(0.2),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'طبيق رواح هو تطبيق دعم نفسي ذاتي يساعد المستخدم على متابعة حالته المزاجية يوميًا، وتسجيل القيم التي يعيش بها، كما يوفّر اقتراحات لأنشطة تعزز المشاعر الإيجابية وتساعده في التعامل مع المشاعر السلبية. يتيح للمستخدم تتبُّع إنجازاته وأهدافه، وتوثيق مشاعره وتجربته، بالإضافة إلى إمكانية التحدّث مع شات بوت صديق اسمه "رواح"، يقدم الدعم من منظور نفسي وروحي مستوحى من الوحي.',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'الإصدار: 1.0.0',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'المطورون:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.accent,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  _buildDeveloper('سهيلة عريف'),
                  _buildDeveloper('أسماء محمد سعد'),
                  _buildDeveloper('ميرفت العفيفي'),
                  _buildDeveloper('رفيدة عصام'),
                  _buildDeveloper('منار'),
                ],
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
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
        );
      },
    );
  }

  Widget _buildDeveloper(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.person, size: 20, color: AppColors.accent),
          const SizedBox(width: 10),
          Text(name, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppColors.goldenAccent.withOpacity(0.2),
            title: const Text(
              'تأكيد تسجيل الخروج',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: const Text(
              'هل تريد فعلاً تسجيل الخروج من التطبيق؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await AuthService().signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'تأكيد',
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
            ],
          ),
        );
      },
    );
  }
}
