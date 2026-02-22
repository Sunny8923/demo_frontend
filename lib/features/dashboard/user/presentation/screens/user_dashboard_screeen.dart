import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/features/dashboard/user/presentation/widgets/user_dashboard_summary.dart';
import 'package:frontend/features/dashboard/user/presentation/widgets/user_dashboard_wuick_actions.dart';
import 'package:gap/gap.dart';

import '../../../../../core/ui/app_scaffold.dart';

import '../../../../auth/presentation/providers/current_user_provider.dart';

import '../providers/user_dashboard_provider.dart';

import '../widgets/user_dashboard_header.dart';

class UserDashboardScreen extends ConsumerWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////
    /// WATCH USER
    ////////////////////////////////////////////////////////////

    final user = ref.watch(currentUserProvider).value;

    ////////////////////////////////////////////////////////////
    /// WATCH DASHBOARD
    ////////////////////////////////////////////////////////////

    final dashboardState = ref.watch(userDashboardProvider);

    ////////////////////////////////////////////////////////////
    /// UI
    ////////////////////////////////////////////////////////////

    return AppScaffold(
      title: "Dashboard",

      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(userDashboardProvider.notifier).refresh();
        },

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: dashboardState.when(
              ////////////////////////////////////////////////////////////
              /// LOADING
              ////////////////////////////////////////////////////////////
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),

              ////////////////////////////////////////////////////////////
              /// ERROR
              ////////////////////////////////////////////////////////////
              error: (error, stack) => Column(
                children: [
                  const Gap(40),

                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.redAccent,
                  ),

                  const Gap(12),

                  const Text("Failed to load dashboard"),

                  const Gap(12),

                  ElevatedButton(
                    onPressed: () {
                      ref.read(userDashboardProvider.notifier).refresh();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),

              ////////////////////////////////////////////////////////////
              /// SUCCESS
              ////////////////////////////////////////////////////////////
              data: (dashboard) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ////////////////////////////////////////////////////////
                    /// HEADER
                    ////////////////////////////////////////////////////////
                    UserDashboardHeader(
                      name: user?.name ?? "User",
                      range: dashboard.range,
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),

                    const Gap(24),

                    ////////////////////////////////////////////////////////
                    /// SUMMARY CARDS
                    ////////////////////////////////////////////////////////
                    UserDashboardSummaryCards(
                      dashboard: dashboard,
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: .1),

                    const Gap(24),

                    ////////////////////////////////////////////////////////
                    /// QUICK ACTIONS
                    ////////////////////////////////////////////////////////
                    const UserDashboardQuickActions()
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: .1),

                    const Gap(24),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
