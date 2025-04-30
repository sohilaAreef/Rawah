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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          
          title: Text(
        widget.value.title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward, color: AppColors.accent),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 250,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(widget.value.image),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),)
                  ],
                ),
              ),
              
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),)
                  ],
                ),
                child: Text(
                  widget.value.description,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.8,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'خطوات التطبيق:',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ),
              
              ...widget.value.steps.map((step) => Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),)
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, 
                        size: 20, 
                        color: AppColors.accent),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.6,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}