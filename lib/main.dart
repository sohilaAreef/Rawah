import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  
import 'package:rawah/logic/value_provider.dart';
import 'package:rawah/screens/value_screen.dart';
import 'screens/home_screen.dart';   

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ValueProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Tajawal',
      ),
      home: HomeScreen(),
    );
  }
}
