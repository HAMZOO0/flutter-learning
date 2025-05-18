import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is ready
  await Firebase.initializeApp(); // Initializes Firebase
  runApp(MyApp()); // Starts the app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase App',
      home: PostScreen(), // You can change this to any home widget
    );
  }
}

// Dummy screen to avoid errors (replace with your own screen)
class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post Screen")),
      body: Center(child: Text("Firebase Initialized")),
    );
  }
}
