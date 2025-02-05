import 'package:flutter/material.dart';
import 'package:rawah/logic/value_provider.dart';
import 'package:provider/provider.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/widgets/selected_value_item.dart';

class SelectedValuesScreen extends StatelessWidget {
  const SelectedValuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
   final valueProvider = Provider.of<ValueProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('قيمك المختارة',
        style: TextStyle(color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold),),
        backgroundColor: AppColors.accent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: valueProvider.selectedValues.length,
        itemBuilder: (context, index) {
          final value = valueProvider.selectedValues[index];
          return SelectedValueItem(value: value);
        },
      ),
    );
  }
}