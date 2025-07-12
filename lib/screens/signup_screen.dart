import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rawah/screens/home_screen.dart';
import 'package:rawah/screens/login_screen.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  String? passwordHelper;
  Color? passwordHelperColor;
  String? confirmPasswordHelper;
  Color? confirmPasswordHelperColor;

  void _checkPasswordStrength(String value) {
    if (value.length < 6) {
      passwordHelper = 'كلمة المرور ضعيفة جداً';
      passwordHelperColor = Colors.red;
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      passwordHelper = 'يفضل استخدام حروف كبيرة وصغيرة وأرقام';
      passwordHelperColor = Colors.orange;
    } else {
      passwordHelper = 'كلمة المرور قوية';
      passwordHelperColor = Colors.green;
    }
    setState(() {});
  }

  void _checkPasswordMatch(String value) {
    if (value != _passwordController.text) {
      confirmPasswordHelper = 'كلمتا المرور غير متطابقتين';
      confirmPasswordHelperColor = Colors.red;
    } else {
      confirmPasswordHelper = 'كلمتا المرور متطابقتان';
      confirmPasswordHelperColor = Colors.green;
    }
    setState(() {});
  }

  Future<void> _signUpWithEmail() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمة المرور غير متطابقة!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      await userCredential.user?.updateDisplayName(
        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      String errorMessage = 'حدث خطأ أثناء إنشاء الحساب.';

      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          errorMessage =
              'هذا البريد مستخدم بالفعل. يبدو أنك قمت بالتسجيل من قبل.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'صيغة البريد غير صحيحة.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'كلمة المرور ضعيفة.';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage, textAlign: TextAlign.right),
          backgroundColor: Colors.red[700],
        ),
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
        child: Column(
          children: [
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.accent, AppColors.darkTeal],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Image.asset(
                      'assets/images/hello.png',
                      height: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'مرحباً بك في رواح!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'لنبدأ رحلتك معنا',
                      style: TextStyle(fontSize: 16, color: Colors.grey[200]),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'الاسم الأول',
                            isPassword: false,
                            controller: _firstNameController,
                            hintText: 'أدخل اسمك الأول',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CustomTextField(
                            label: 'الاسم الأخير',
                            isPassword: false,
                            controller: _lastNameController,
                            hintText: 'أدخل اسمك الأخير',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'البريد الإلكتروني',
                      isPassword: false,
                      controller: _emailController,
                      hintText: 'example@email.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'رقم الهاتف',
                      isPassword: false,
                      controller: _phoneController,
                      hintText: 'مثال: 01012345678',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'كلمة المرور',
                      isPassword: true,
                      controller: _passwordController,
                      hintText: 'أدخل كلمة مرور قوية',
                      helperText: passwordHelper,
                      helperColor: passwordHelperColor,
                      onChanged: (value) {
                        _checkPasswordStrength(value);
                        _checkPasswordMatch(_confirmPasswordController.text);
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'تأكيد كلمة المرور',
                      isPassword: true,
                      controller: _confirmPasswordController,
                      hintText: 'أعد إدخال كلمة المرور',
                      helperText: confirmPasswordHelper,
                      helperColor: confirmPasswordHelperColor,
                      onChanged: (value) => _checkPasswordMatch(value),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'إنشاء الحساب',
                      onPressed: _signUpWithEmail,
                      isLoading: _isLoading,
                      backgroundColor: AppColors.darkTeal,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            ' لديك حساب بالفعل؟ ',
                            style: TextStyle(
                              color: AppColors.darkTeal,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
