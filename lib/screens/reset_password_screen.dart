// reset_password_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rawah/screens/login_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/widgets/custom_button.dart';
import 'package:rawah/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isResetting = false;

  Future<void> _resetPassword() async {
    final newPass = _newPassController.text.trim();
    final confirmPass = _confirmPassController.text.trim();

    if (newPass.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمة المرور يجب أن تكون 8 أحرف على الأقل'),
        ),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('كلمة المرور غير متطابقة')));
      return;
    }

    setState(() => _isResetting = true);

    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(newPass);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث كلمة المرور بنجاح')),
      );

      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'كلمة المرور ضعيفة جداً';
          break;
        case 'requires-recent-login':
          errorMessage = 'يجب تسجيل الدخول مرة أخرى لتغيير كلمة المرور';
          break;
        default:
          errorMessage = 'حدث خطأ أثناء التحديث: ${e.message}';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ غير متوقع: ${e.toString()}')),
      );
    } finally {
      setState(() => _isResetting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                'تحديث كلمة المرور',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                label: 'كلمة المرور الجديدة',
                isPassword: true,
                controller: _newPassController,
                hintText: 'أدخل كلمة مرور قوية (8+ أحرف)',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'تأكيد كلمة المرور',
                isPassword: true,
                controller: _confirmPassController,
                hintText: 'أعد إدخال كلمة المرور',
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'تحديث',
                onPressed: _resetPassword,
                isLoading: _isResetting,
                backgroundColor: AppColors.darkTeal,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
