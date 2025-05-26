import 'package:finsavvy/core/router/app_router.dart';
import 'package:flutter/material.dart';

class FinSavvyApp extends StatelessWidget {
  const FinSavvyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: routerApp);
  }
}
