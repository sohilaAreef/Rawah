import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:rawah/logic/emotion_provider.dart';
import 'package:rawah/logic/goal_provider.dart';
import 'package:rawah/logic/value_provider.dart';
import 'package:rawah/screens/login_screen.dart';
import 'package:rawah/services/entry_service.dart';
import 'package:rawah/services/goal_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ValueProvider()),
        ChangeNotifierProvider(create: (context) => EmotionProvider()),
        Provider(create: (context) => EntryService()),
        Provider(create: (context) => GoalService()),
        ChangeNotifierProvider(
          create: (context) => GoalProvider(context.read<GoalService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رواح',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
