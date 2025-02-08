import 'package:flutter/material.dart';
import 'package:rawah/models/value_model.dart';
import 'package:rawah/utils/app_colors.dart';

class ValueDetailsScreen extends StatefulWidget {
 final ValueModel value;

  const ValueDetailsScreen({super.key, required this.value});

  @override
  State<ValueDetailsScreen> createState() => _ValueDetailsScreenState();
}

class _ValueDetailsScreenState extends State<ValueDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.value.title,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.accent),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.value.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(widget.value.description,
              style: TextStyle(
                fontSize: 18,
                height: 1.5,
              ),
              ),
            ),
            SizedBox(height: 16),
            ...widget.value.steps.map((step) => ListTile(
              leading: Icon(Icons.check, color: Colors.purple),
              title: Text(step),
            ),),
          ],),
      ),
    );
  }
}