import 'package:flutter/material.dart';
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

    redirect: (context, state) {
      final authAsync = authState;

      if (authAsync.isLoading) return null;

      final loggedIn = authAsync.value ?? false;

      if (!loggedIn && state.uri.path != AppRoutes.login) {
        return AppRoutes.login;
      }

      if (loggedIn && state.uri.path == AppRoutes.login) {
        return AppRoutes.dashboard;
      }

      return null;
    },

    routes: [
      ////////////////////////////////////////////////////////////
      /// ROOT
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
      /// 🔥 SHELL (GLOBAL UI)
      ////////////////////////////////////////////////////////////
      ShellRoute(
        builder: (context, state, child) {
          return DashboardShell(child: child);
        },
        routes: [
          ////////////////////////////////////////////////////////////
          /// DASHBOARD (ROLE BASED)
          ////////////////////////////////////////////////////////////
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardRouter(),
          ),

          ////////////////////////////////////////////////////////////
          /// SETTINGS (REAL)
          ////////////////////////////////////////////////////////////
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),

          ////////////////////////////////////////////////////////////
          /// PLACEHOLDER ROUTES
          ////////////////////////////////////////////////////////////
          GoRoute(
            path: AppRoutes.jobs,
            builder: (context, state) => const _ComingSoon("Jobs"),
          ),
          GoRoute(
            path: AppRoutes.candidates,
            builder: (context, state) => const _ComingSoon("Candidates"),
          ),
          GoRoute(
            path: AppRoutes.applications,
            builder: (context, state) => const _ComingSoon("Applications"),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            builder: (context, state) => const _ComingSoon("Analytics"),
          ),
          GoRoute(
            path: AppRoutes.partners,
            builder: (context, state) => const _ComingSoon("Partners"),
          ),
          GoRoute(
            path: AppRoutes.recruiters,
            builder: (context, state) => const _ComingSoon("Recruiters"),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const _ComingSoon("Profile"),
          ),
        ],
      ),
    ],
  );
});

class _ComingSoon extends StatelessWidget {
  final String title;

  const _ComingSoon(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, size: 48),
          const SizedBox(height: 16),
          Text(
            "$title - Coming Soon",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
