import 'package:finsavvy/core/consts/route_config.dart';
import 'package:finsavvy/features/auth/components/pages/auth_page.dart';
import 'package:finsavvy/features/auth/components/pages/register_page.dart';
import 'package:finsavvy/features/dashboard/components/pages/home_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/components/blocs/auth_bloc/bloc/auth_bloc.dart';
import '../../infra/injector_container.dart';

final routerApp = GoRouter(
  initialLocation: AppRouter.homePath,
  debugLogDiagnostics: true,
  redirect: (context, state) async {
    final authBloc = getIt<AuthBloc>();
    final isLoggedIn = authBloc.state is AuthSuccessState;
    final isAuthPage =
        state.matchedLocation == AppRouter.authPath ||
        state.matchedLocation == AppRouter.registerPath;

    if (isLoggedIn && isAuthPage) {
      return AppRouter.homePath;
    }

    if (!isLoggedIn && !isAuthPage) {
      return AppRouter.authPath;
    }

    return null;
  },
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
    GoRoute(
      path: AppRouter.registerPath,
      name: AppRouter.registerNamePath,
      builder: (context, state) {
        return RegisterPage();
      },
    ),
  ],
);
