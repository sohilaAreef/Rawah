import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rawah/utils/app_sounds.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rawah/logic/emotion_provider.dart';
import 'package:rawah/logic/goal_provider.dart';
import 'package:rawah/logic/value_provider.dart';
import 'package:rawah/screens/home_screen.dart';
import 'package:rawah/screens/login_screen.dart';
import 'package:rawah/screens/onboarding_screen.dart';
import 'package:rawah/services/entry_service.dart';
import 'package:rawah/services/goal_service.dart';
import 'package:rawah/utils/app_colors.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await AppSounds.initForWeb();

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

  Future<Widget> getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    final user = FirebaseAuth.instance.currentUser;

    if (seenOnboarding) {
      return user != null ? const HomeScreen() : LoginScreen();
    } else {
      return const OnboardingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رواح',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primary,
        primaryColor: AppColors.accent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: const Color.fromARGB(255, 230, 234, 241),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
        ),
      ),
      home: FutureBuilder<Widget>(
        future: getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('حدث خطأ أثناء التهيئة')),
            );
          } else if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const Scaffold(
              body: Center(child: Text('لم يتم العثور على شاشة')),
            );
          }
        },
      ),
    );
  }
}
