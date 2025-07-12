import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:rawah/data/motivational_messages.dart';
import 'package:rawah/services/notification_service.dart';
import 'package:rawah/utils/app_sounds.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rawah/screens/onboarding_screen.dart';
import 'package:rawah/screens/login_screen.dart';
import 'package:rawah/screens/home_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

import 'logic/emotion_provider.dart';
import 'logic/goal_provider.dart';
import 'logic/value_provider.dart';
import 'services/entry_service.dart';
import 'services/goal_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

  await dotenv.load();
  await AppSounds.initForWeb();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await requestNotificationPermission();
  await _initializeAppCheck();

  final noti = NotificationService();
  await noti.init();
  await noti.scheduleDailyReminder(
    id: 1,
    getMessageOfTheDay: MotivationalMessages().getMessageOfTheDay,
  );
  await noti.scheduleEveningReminder();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
  final user = FirebaseAuth.instance.currentUser;

  late final Widget firstScreen;
  if (!seenOnboarding) {
    firstScreen = const OnboardingScreen();
  } else if (user == null) {
    firstScreen = const LoginScreen();
  } else {
    firstScreen = const HomeScreen(initialIndex: 4);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ValueProvider()..loadFromFirebase(),
        ),
        ChangeNotifierProvider(create: (_) => EmotionProvider()),
        Provider(create: (_) => EntryService()),
        Provider(create: (_) => GoalService()),
        ChangeNotifierProvider(
          create: (context) => GoalProvider(context.read<GoalService>()),
        ),
      ],
      child: MyApp(startScreen: firstScreen),
    ),
  );
}

Future<void> _initializeAppCheck() async {
  try {
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
  } catch (e) {
    print('App Check initialization error: $e');
  }
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.request();
  if (status.isGranted) {
    print("✅ تم منح إذن الإشعارات");
  } else {
    print("❌ تم رفض إذن الإشعارات");
  }
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
  const MyApp({super.key, required this.startScreen});

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
      home: startScreen,
    );
  }
}
