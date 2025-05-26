import 'package:finsavvy/core/router/app_router.dart';
import 'package:finsavvy/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FinSavvyApp extends StatelessWidget {
  const FinSavvyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: routerApp,
    );
  }
}
