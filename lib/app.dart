import 'package:finsavvy/core/router/app_router.dart';
import 'package:finsavvy/core/theme/app_theme.dart';
import 'package:finsavvy/features/auth/components/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:finsavvy/infra/injector_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinSavvyApp extends StatelessWidget {
  const FinSavvyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: routerApp,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => getIt<AuthBloc>(),
          child: child,
        );
      },
    );
  }
}
