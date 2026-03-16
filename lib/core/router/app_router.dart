import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../layout/dashboard_shell.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/shared/dashboard_router.dart';
import '../../features/settings/settings_screen.dart';

import '../../features/auth/presentation/providers/auth_state_provider.dart';

import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,

    ////////////////////////////////////////////////////////////
    /// AUTH GUARD
    ////////////////////////////////////////////////////////////
    redirect: (context, state) {
      final authAsync = authState;

      if (authAsync.isLoading) {
        return null;
      }

      final loggedIn = authAsync.value ?? false;

      final loggingIn = state.uri.path == AppRoutes.login;

      if (!loggedIn && !loggingIn) {
        return AppRoutes.login;
      }

      if (loggedIn && loggingIn) {
        return AppRoutes.dashboard;
      }

      return null;
    },

    ////////////////////////////////////////////////////////////
    /// ROUTES
    ////////////////////////////////////////////////////////////
    routes: [
      ////////////////////////////////////////////////////////////
      /// SPLASH
      ////////////////////////////////////////////////////////////
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const AppStartupScreen(),
      ),

      ////////////////////////////////////////////////////////////
      /// LOGIN
      ////////////////////////////////////////////////////////////
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      ////////////////////////////////////////////////////////////
      /// DASHBOARD SHELL
      ////////////////////////////////////////////////////////////
      ShellRoute(
        builder: (context, state, child) {
          return DashboardShell(child: child);
        },
        routes: [
          ////////////////////////////////////////////////////////////
          /// DASHBOARD
          ////////////////////////////////////////////////////////////
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardRouter(),
          ),

          ////////////////////////////////////////////////////////////
          /// SETTINGS
          ////////////////////////////////////////////////////////////
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
