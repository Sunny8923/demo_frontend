import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/features/dashboard/recruiter/presentation/screens/recruiter_dashboard_screen.dart';
import 'package:gap/gap.dart';

import 'package:frontend/features/dashboard/admin/presentation/screens/admin_dashboard_screeen.dart';
import 'package:frontend/features/dashboard/user/presentation/screens/user_dashboard_screeen.dart';
import 'package:frontend/features/dashboard/partner/presentation/screens/partner_dashboard_screen.dart';

import 'package:frontend/features/partners/presentation/providers/partner_me_provider.dart';
import 'package:frontend/features/partners/presentation/screens/pending_approval_screen.dart';

import '../../auth/presentation/providers/current_user_provider.dart';

class DashboardRouter extends ConsumerWidget {
  const DashboardRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(currentUserProvider);

    return userState.when(
      loading: () => const _RouterLoadingScreen(),

      error: (e, _) => _RouterErrorScreen(message: e.toString()),

      data: (user) {
        if (user == null) {
          return const _RouterErrorScreen(message: "User not found");
        }

        switch (user.role) {
          case "ADMIN":
            return const AdminDashboardScreen().animate().fadeIn(
              duration: 300.ms,
            );

          case "PARTNER":
            final partnerState = ref.watch(partnerMeProvider);

            return partnerState.when(
              loading: () => const _RouterLoadingScreen(),

              error: (_, _) {
                // 403 → not approved
                return const PendingApprovalScreen().animate().fadeIn(
                  duration: 300.ms,
                );
              },

              data: (partner) {
                if (partner == null || partner.status != "APPROVED") {
                  return const PendingApprovalScreen().animate().fadeIn(
                    duration: 300.ms,
                  );
                }

                return const PartnerDashboardScreen().animate().fadeIn(
                  duration: 300.ms,
                );
              },
            );

          case "RECRUITER":
            return const RecruiterDashboardScreen().animate().fadeIn(
              duration: 300.ms,
            );

          case "USER":
          default:
            return const UserDashboardScreen().animate().fadeIn(
              duration: 300.ms,
            );
        }
      },
    );
  }
}

///////////////////////////////////////////////////////////////
/// PREMIUM LOADING SCREEN
///////////////////////////////////////////////////////////////

class _RouterLoadingScreen extends StatelessWidget {
  const _RouterLoadingScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                  strokeWidth: 3,
                  color: theme.colorScheme.primary,
                )
                .animate(onPlay: (c) => c.repeat())
                .scale(
                  duration: 800.ms,
                  begin: const Offset(.8, .8),
                  end: const Offset(1, 1),
                ),

            const Gap(24),

            Text(
              "Loading your workspace...",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ).animate().fadeIn(delay: 200.ms),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// PREMIUM ERROR SCREEN
///////////////////////////////////////////////////////////////

class _RouterErrorScreen extends StatelessWidget {
  final String message;

  const _RouterErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ).animate().fadeIn().scale(),

              const Gap(16),

              Text(
                "Something went wrong",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Gap(8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),

              const Gap(24),

              ElevatedButton(
                onPressed: () {
                  // simple reload
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardRouter()),
                  );
                },
                child: const Text("Retry"),
              ).animate().fadeIn(delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}
