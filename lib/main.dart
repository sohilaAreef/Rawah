import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';
import 'package:rawah/utils/app_sounds.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

import 'package:rawah/logic/emotion_provider.dart';
import 'package:rawah/logic/goal_provider.dart';
import 'package:rawah/logic/value_provider.dart';
import 'package:rawah/services/entry_service.dart';
import 'package:rawah/services/goal_service.dart';
import 'package:rawah/screens/splash_screen.dart';
import 'package:rawah/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await AppSounds.initForWeb();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await _initializeAppCheck();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ValueProvider()),
        ChangeNotifierProvider(create: (_) => EmotionProvider()),
        Provider(create: (_) => EntryService()),
        Provider(create: (_) => GoalService()),
        ChangeNotifierProvider(
          create: (context) => GoalProvider(context.read<GoalService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _initializeAppCheck() async {
  try {
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );

    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

    final token = await FirebaseAppCheck.instance.getToken(true);
    print('App Check Token: $token');
  } catch (e) {
    print('Error initializing App Check: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
