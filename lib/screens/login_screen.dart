import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30),
              CustomTextField(
                label: 'Email ID',
                isPassword: false,
              ),
              SizedBox(height: 20),
              CustomTextField(
                label: 'Password',
                isPassword: true,
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot?',
                    style: TextStyle(color: AppColors.accent),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center( 
                child: CustomButton(
                  text: 'Login',
                  onPressed: () {
                    
                  },
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Text('Or login with...', style: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      
                    },
                    icon: Icon(Icons.g_mobiledata, size: 36, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {
                      
                    },
                    icon: Icon(Icons.facebook, size: 36, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {
                      
                    },
                    icon: Icon(Icons.apple, size: 36, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New to Rawah? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> SignUpScreen()
                        ),
                        );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
