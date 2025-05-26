import 'package:finsavvy/core/consts/route_config.dart';
import 'package:finsavvy/features/auth/components/pages/auth_page.dart';
import 'package:finsavvy/features/dashboard/components/pages/home_page.dart';
import 'package:go_router/go_router.dart';

final routerApp = GoRouter(
  initialLocation: AppRouter.homePath,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRouter.homePath,
      name: AppRouter.homeNamePath,
      builder: (context, state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: AppRouter.authPath,
      name: AppRouter.authNamePath,
      builder: (context, state) {
        return AuthPage();
      },
    ),
  ],
);
