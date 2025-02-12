import 'package:flutter/material.dart';
import 'package:rawah/screens/home_screen.dart';
import 'package:rawah/screens/signup_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 100),
                Center(
                  child: Image.asset(
                    'assets/images/freepik__upload__54995.png',
                    height: 150,
                    width: double.infinity, 
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(height: 30),
                CustomTextField(
                  label: 'البريد الإلكتروني',
                  isPassword: false,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  label: 'كلمة المرور',
                  isPassword: true,
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'نسيت؟',
                      style: TextStyle(color: AppColors.accent),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center( 
                  child: CustomButton(
                    text: 'تسجيل الدخول',
                    onPressed: () {
                      Navigator.push(
                          context,
                           MaterialPageRoute(builder: (context) => HomeScreen()));
                    },
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'أو سجل الدخول باستخدام...',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.g_mobiledata, size: 36, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.facebook, size: 36, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.apple, size: 36, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(' هل أنت جديد على رواح؟ '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          'إنشاء حساب',
                          style: TextStyle(color: AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
