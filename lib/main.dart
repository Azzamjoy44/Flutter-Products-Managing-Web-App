import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';

// The main entry point of the app
Future<void> main() async {
  // Ensure Flutter bindings are initialized before using any platform services
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options specific to the current platform (Android/iOS/Web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // Run the app after Firebase is initialized
  runApp(MyApp());
}

// The main application widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

