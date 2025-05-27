import 'package:finsavvy/app.dart';
import 'package:finsavvy/firebase_options.dart';
import 'package:finsavvy/infra/injector_container.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await init();
  return runApp(const FinSavvyApp());
}
