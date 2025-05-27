import 'package:finsavvy/app.dart';
import 'package:finsavvy/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Ideal time to initialize
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9090);
  return runApp(const FinSavvyApp());
}
