import 'package:flutter/material.dart';
import 'package:rawah/models/value_model.dart';
import 'package:rawah/screens/value_details_screen.dart';
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ValueDetailsScreen(value: value),
              ),
            );
          },
          
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              
              leading: CircleAvatar(
                backgroundImage: NetworkImage(value.image),
              ),
              title: Text(
                value.title,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                value.description,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.accent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
