import 'package:flutter/material.dart';

class ValueModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<String> steps;

  ValueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.steps,
  });
}
