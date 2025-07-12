import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('لا يوجد تكوين ويب');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('المنصة غير مدعومة');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAyc47mvSrDaKVzLGQOCASqUpoTQH1Z3Gg",
    appId: "1:444594661353:android:e3b3ee31d8e48ff5648d78",
    messagingSenderId: "444594661353",
    projectId: "rawah-d3515",
    storageBucket: "rawah-d3515.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAyc47mvSrDaKVzLGQOCASqUpoTQH1Z3Gg",
    appId: "1:444594661353:ios:YOUR_IOS_APP_ID",
    messagingSenderId: "444594661353",
    projectId: "rawah-d3515",
    storageBucket: "rawah-d3515.firebasestorage.app",
    iosBundleId: "com.sohila.rawah",
  );
}
