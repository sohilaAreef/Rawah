import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/logic/value_provider.dart';
import 'package:rawah/screens/value_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/widgets/selected_value_item.dart';

class SelectedValuesScreen extends StatelessWidget {
  const SelectedValuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final valueProvider = Provider.of<ValueProvider>(context);
    final selected = valueProvider.selectedValues;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: false,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            "قيمك المختارة",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: AppColors.accent,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: selected.isEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Image.asset(
                  'assets/images/empty-box.png',
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'لم تقم بإضافة أي قيم بعد.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ValuesScreen()),
                    );
                  },
                  child: const Text(
                    'أضف قيمك',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: selected.length,
              itemBuilder: (context, index) {
                return SelectedValueItem(value: selected[index]);
              },
            ),
    );
  }
}
