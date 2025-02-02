import 'package:flutter/material.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/widgets/custom_button.dart';
import 'package:rawah/widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
              SizedBox(height: 100,),
              Center(child: Image.asset(
                'assets/images/flat-hand-drawn-hygge-lifestyle-illustration_23-2148827883.jpg',
                height: 150,
                width: double.infinity, 
              ),),
              SizedBox(height: 20,),
              Text('Sign Up', 
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
              ),
              SizedBox(height: 30),
              CustomTextField(
                label: 'full name',
               isPassword: false
               ),
              SizedBox(height: 20,),
              CustomTextField(
                label: 'Email ID',
               isPassword: false
               ),
              SizedBox(height: 20,),
              CustomTextField(
                label: 'Password',
                 isPassword: true
                 ),
              SizedBox(height: 20,),
              CustomTextField(
                label: 'Confirm Password',
                 isPassword: true
                 ),
              SizedBox(height: 20,),
              Center(
                child: CustomButton(
                  text: 'Sign Up',
                   onPressed: (){

                   },
                   ),
              ),
              SizedBox(height: 30),
              Center(
                child: Text('Or sign up with...',
                style: TextStyle(color: Colors.grey),),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: (){

                    }, 
                    icon: Icon(Icons.g_mobiledata, size: 36, color: Colors.blue,),
                  ),
                  IconButton(
                    onPressed: (){

                    }, 
                    icon: Icon(Icons.facebook, size: 36, color: Colors.blue,),
                  ),
                  IconButton(
                    onPressed: (){

                    }, 
                    icon: Icon(Icons.apple, size: 36, color: Colors.black,),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                   GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text(
                      'login',
                      style: TextStyle(color: AppColors.accent),
                    ),
                   )

                  ],
                ),
              )
            ],
          ),),
      ),
    );
  }
}