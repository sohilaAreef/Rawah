import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/logic/value_provider.dart';
import 'package:rawah/models/value_model.dart';
import 'package:rawah/utils/app_colors.dart';

class SelectedValueItem extends StatelessWidget {
  final ValueModel value;

  const SelectedValueItem({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.accent;
    final lightAccent = accentColor.withOpacity(0.1);
    final darkAccent = Color.lerp(accentColor, Colors.black, 0.2)!;

    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: accentColor.withOpacity(0.3), width: 1),
      ),
      color: lightAccent,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: lightAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor, width: 1.5),
                  ),
                  child: Icon(value.icon, color: accentColor, size: 32),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      value.title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: darkAccent,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              value.description,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey[800],
                height: 1.6,
              ),
            ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  Provider.of<ValueProvider>(
                    context,
                    listen: false,
                  ).toggleValue(value);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'إزالة هذه القيمة',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
