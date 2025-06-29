import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rawah/screens/reset_password_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/widgets/custom_button.dart';
import 'package:rawah/widgets/custom_text_field.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isVerifying = false;

  Future<void> _verifyOtp() async {
    setState(() => _isVerifying = true);

    final smsCode = _otpController.text.trim();

    if (smsCode.isEmpty || smsCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال كود مكون من 6 أرقام')),
      );
      setState(() => _isVerifying = false);
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('كود التحقق غير صحيح')));
    } finally {
      setState(() => _isVerifying = false);
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
              Text(
                'أدخل كود التحقق المرسل إلى:',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                label: 'كود التحقق',
                isPassword: false,
                controller: _otpController,
                hintText: 'أدخل الكود هنا',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'تحقق',
                onPressed: _verifyOtp,
                isLoading: _isVerifying,
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
