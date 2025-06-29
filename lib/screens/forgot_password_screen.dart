import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rawah/screens/otp_verification_screen.dart';
import 'package:rawah/screens/reset_password_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/widgets/custom_button.dart';
import 'package:rawah/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '+20');
  String _method = 'email';
  bool _isLoading = false;

  Future<void> _resetPasswordWithEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال بريد إلكتروني صحيح')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال رابط إعادة التعيين إلى بريدك')),
      );

      // إضافة تأخير للسماح بعرض الرسالة قبل العودة
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الإرسال: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyPhone() async {
    final phone = _phoneController.text.trim();
    final code = _countryCodeController.text.trim();

    if (phone.isEmpty || phone.length < 9) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى إدخال رقم هاتف صحيح')));
      return;
    }

    final fullPhone = '$code$phone';

    try {
      setState(() => _isLoading = true);

      // استخدام VerificationProvider لتجنب مشكلات الجلسة
      final verificationProvider = PhoneAuthProvider.credential;

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // تسجيل الدخول التلقائي عند اكتمال التحقق
          await FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ResetPasswordScreen(),
            ),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('فشل التحقق: ${e.message}')));
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                verificationId: verificationId,
                phoneNumber: fullPhone,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء التحقق: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  'استرجاع كلمة المرور',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkTeal,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('بالبريد الإلكتروني'),
                      selected: _method == 'email',
                      onSelected: (val) => setState(() => _method = 'email'),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('برقم الهاتف'),
                      selected: _method == 'phone',
                      onSelected: (val) => setState(() => _method = 'phone'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (_method == 'email')
                  CustomTextField(
                    label: 'البريد الإلكتروني',
                    isPassword: false,
                    controller: _emailController,
                    hintText: 'example@email.com',
                    keyboardType: TextInputType.emailAddress,
                  )
                else ...[
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          label: 'رمز الدولة',
                          isPassword: false,
                          controller: _countryCodeController,
                          hintText: '+20',
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: CustomTextField(
                          label: 'رقم الهاتف',
                          isPassword: false,
                          controller: _phoneController,
                          hintText: '10xxxxxxxx',
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 30),
                CustomButton(
                  text: 'استرجاع',
                  onPressed: () async {
                    if (_method == 'email') {
                      await _resetPasswordWithEmail();
                    } else {
                      await _verifyPhone();
                    }
                  },
                  backgroundColor: AppColors.darkTeal,
                  textColor: Colors.white,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
