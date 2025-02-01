import 'package:flutter/material.dart';
import 'package:rawah/screens/achievements_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rawah',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AchievementsScreen(), 
    );
  }
}
