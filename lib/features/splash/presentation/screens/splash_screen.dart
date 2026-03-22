import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/auth/presentation/providers/auth_state_provider.dart';

class AppStartupScreen extends ConsumerWidget {
  const AppStartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      ////////////////////////////////////////////////////////////
      /// LOADING
      ////////////////////////////////////////////////////////////
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      ////////////////////////////////////////////////////////////
      /// ERROR → LOGIN
      ////////////////////////////////////////////////////////////
      error: (_, __) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/login');
        });

        return const SizedBox();
      },

      ////////////////////////////////////////////////////////////
      /// DATA
      ////////////////////////////////////////////////////////////
      data: (isLoggedIn) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isLoggedIn) {
            context.go('/dashboard'); // ✅ THIS IS THE FIX
          } else {
            context.go('/login');
          }
        });

        return const SizedBox(); // temporary blank
      },
    );
  }
}
