import 'package:finsavvy/app.dart';
import 'package:finsavvy/infra/injector_container.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  return runApp(const FinSavvyApp());
}
