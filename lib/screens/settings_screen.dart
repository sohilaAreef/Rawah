import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rawah/screens/profile_screen.dart';
import 'package:rawah/screens/login_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
              icon: Icons.mail_outline,
              title: 'تواصل معنا',
              onTap: () => _showContactOptions(context),
            ),

            _buildSettingItem(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              color: Colors.red,
              onTap: () => _showLogoutConfirmation(context),
            ),
            _buildSettingItem(
              icon: Icons.delete_forever,
              title: 'حذف الحساب',
              color: Colors.red,
              onTap: () => _showDeleteAccountConfirmation(context),
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
            backgroundColor: const Color.fromARGB(255, 255, 253, 226),
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
                    'رواح هو رفيقك في رحلة النمو الشخصي والتوازن النفسي. يساعدك على:\n\n'
                    '• تحديد أهدافك: تنظيم أهدافك والسعي لتحقيقها بخطوات واضحة.\n'
                    '• تسجيل الإنجازات: تذكر نجاحاتك الصغيرة والكبيرة لتعزيز ثقتك بنفسك.\n'
                    '• الامتنان: تدوين الأشياء التي تشعر بالامتنان لها لزيادة شعورك بالسعادة والرضا.\n'
                    '• تتبع المشاعر اليومية: فهم مشاعرك بشكل أفضل والتعامل معها بطريقة صحية.\n'
                    '• اختبار المشاعر السلبية: تحليل مشاعرك السلبية وكيفية التعامل معها.\n'
                    '• تحديد القيم الشخصية: اكتشاف قيمك الأساسية ووضع خطوات عملية لتطبيقها في حياتك.\n\n'
                    'باختصار، رواح هو مساحة آمنة لك للاعتناء بنفسك وتحقيق أفضل نسخة منك.',
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
            backgroundColor: const Color.fromARGB(255, 255, 253, 226),
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

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(255, 245, 223, 156),
            title: const Text(
              'حذف الحساب',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: const Text(
              'هل أنت متأكد أنك تريد حذف حسابك بشكل دائم؟\n\nهذا الإجراء لا يمكن التراجع عنه وسيتم حذف جميع بياناتك.',
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
                      onPressed: () => _deleteAccount(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'حذف',
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

  void _showContactOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(255, 255, 253, 226),
            title: const Text(
              'تواصل معنا',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: AppColors.accent),
                  title: const Text(
                    'تواصل مع المطور',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _launchEmail('sohilaarif01@gmail.com');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.group, color: AppColors.accent),
                  title: const Text(
                    'تواصل مع فريق رواح',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _launchEmail('rawahteem@gmail.com');
                  },
                ),
              ],
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
                    'إغلاق',
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

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح البريد الإلكتروني'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      if (user.photoURL != null) {
        try {
          await FirebaseStorage.instance.refFromURL(user.photoURL!).delete();
        } catch (e) {
          print('Error deleting profile image: $e');
        }
      }

      await user.delete();

      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف حسابك بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في حذف الحساب: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
