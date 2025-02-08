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
        toolbarHeight: 80,
        centerTitle: false, 
         title: const Align(
          alignment: Alignment.centerRight,
           child: Text("قيمك المختارة",
           style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
           ),),),
        backgroundColor: AppColors.accent,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppColors.secondary),
        
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: valueProvider.selectedValues.length,
        itemBuilder: (context, index) {
          return SelectedValueItem(value: valueProvider.selectedValues[index]);
        },
      ),
    );
  }
}