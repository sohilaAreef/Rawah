import 'package:flutter/material.dart';
import 'package:rawah/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController? controller;
  const CustomTextField({super.key, required this.label, required this.isPassword, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.accent)
          ),
          suffixIcon: isPassword? Icon(Icons.visibility_off) : null,
 ),
    );
  }
}