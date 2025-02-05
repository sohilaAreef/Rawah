import 'package:flutter/material.dart';
import 'package:rawah/models/value_model.dart';
import 'package:rawah/utils/app_colors.dart';

class SelectedValueItem extends StatelessWidget {
  final ValueModel value;
  const SelectedValueItem({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child:
         ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(value.image),
          ),
          title: Text(value.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          ),
          subtitle: Text(value.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon( Icons.chevron_right,
          color: AppColors.accent,),
         )
    );
  }
}