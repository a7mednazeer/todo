import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/home_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const ToDoApp());
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
    // Fallback or show error
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text("Startup Error: $e")))));
  }
}
