import 'package:atds/add.dart';
import 'package:atds/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      // For Web
      await Firebase.initializeApp(
      );
    } else {
      // For Mobile (iOS/Android)
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyD1QKls0JQyCCXINYw0oBHhwx4r3n-n19E",
          authDomain: "attende-c1c35.firebaseapp.com",
          projectId: "attende-c1c35",
          storageBucket: "attende-c1c35.appspot.com",
          messagingSenderId: "739603245811",
          appId: "1:739603245811:web:2697e62ca55d04ba07a586",
        ),
      );
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
