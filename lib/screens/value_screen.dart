import 'package:flutter/material.dart';
import 'package:rawah/screens/home_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import '../../data/values_data.dart';
import '../widgets/value_card.dart';

class ValuesScreen extends StatelessWidget {
  const ValuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        toolbarHeight: 80,
        centerTitle: false, 
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            "اختر قيمك الشخصية",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: valuesList.isEmpty
          ? const Center(child: Text("لا توجد قيم متاحة"))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: valuesList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final value = valuesList[index];
                return ValueCard(value: value);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.check, color: Colors.white),
        onPressed: () {
          print("تم الضغط على زر التأكيد في صفحة القيم");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(initialIndex: 1),
            ),
          );
        },
      ),
    );
  }
}
