import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.blueGrey[800],
      ),
      home: HomeScreen(),
    );
  }
}

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyC8k2xeO1Lo24dcYWk2cl2M2XIaHclCxM0",
        appId: "1:139848074964:web:af46f21b3e1e5124971d41",
        messagingSenderId: "139848074964",
        projectId: "appgenesiscomplierapplication",
      ),
    );

    // Explicitly initialize Firebase Auth
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
    if (e is FirebaseException) {
      print('Firebase exception details: ${e.message}');
    }
  }
}