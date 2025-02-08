import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/logic/value_provider.dart';
import 'package:rawah/models/value_model.dart';
import 'package:rawah/utils/app_colors.dart';

class ValueCard extends StatelessWidget {

  final ValueModel value;

  const ValueCard({super.key, required this.value});

  @override
  Widget build(BuildContext context) {

    final valueProvider = Provider.of<ValueProvider>(context);
    final isSelected = valueProvider.isSelected(value);

    return GestureDetector(
      onTap: () => valueProvider.toggleValue(value),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.grey.shade400,
            width: 2,
          ),
          image: DecorationImage(
            image: NetworkImage(value.image,),
            fit: BoxFit.cover,
            colorFilter: isSelected
                ? ColorFilter.mode(
                    AppColors.accent.withOpacity(0.5),
                    BlendMode.darken,
                  )
                : null,
         ),
      ),
      child: Center(
        child: Text(
          value.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            backgroundColor: isSelected? AppColors.accent.withOpacity(0.5): null,
          ),
        ),
      ),
      ),
    );
  }
}