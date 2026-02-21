import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/features/dashboard/admin/presentation/widgets/dashboard_distribution_chart.dart';
import 'package:frontend/features/dashboard/admin/presentation/widgets/dashboard_pipeline.dart';
import 'package:gap/gap.dart';

import '../../../../../core/ui/app_scaffold.dart';

import '../../../../auth/presentation/providers/current_user_provider.dart';

import '../providers/admin_dashboard_provider.dart';

import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_summary_cards.dart';

import '../widgets/dashboard_trends_chart.dart';
import '../widgets/dashboard_leaderboards.dart';
import '../widgets/dashboard_quick_actions.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(adminDashboardProvider);

    final currentUser = ref.watch(currentUserProvider).value;

    return AppScaffold(
      title: "Admin Dashboard",

      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(adminDashboardProvider.notifier).refresh();
        },

        child: dashboardState.when(
          loading: () => const _DashboardLoading(),

          error: (error, stack) => _DashboardError(
            error: error.toString(),
            onRetry: () {
              ref.read(adminDashboardProvider.notifier).refresh();
            },
          ),

          data: (dashboard) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  ////////////////////////////////////////////////////////////
                  /// Header
                  ////////////////////////////////////////////////////////////
                  DashboardHeader(
                    adminName: currentUser?.name ?? "Admin",
                    range: dashboard.range,
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),

                  const Gap(20),

                  ////////////////////////////////////////////////////////////
                  /// Summary Cards
                  ////////////////////////////////////////////////////////////
                  DashboardSummaryCards(
                    summary: dashboard.summary,
                    summaryChange: dashboard.summaryChange,
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: .1),

                  const Gap(24),

                  ////////////////////////////////////////////////////////////
                  /// Pipeline Funnel
                  ////////////////////////////////////////////////////////////
                  DashboardPipelineWidget(
                    pipeline: dashboard.pipeline,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: .1),

                  const Gap(24),

                  ////////////////////////////////////////////////////////////
                  /// Trends Chart
                  ////////////////////////////////////////////////////////////
                  DashboardTrendsChart(
                    trends: dashboard.trends,
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: .1),

                  const Gap(24),

                  ////////////////////////////////////////////////////////////
                  /// Distribution Chart
                  ////////////////////////////////////////////////////////////
                  AdminDistributionChart(
                    distribution: dashboard.distribution,
                  ).animate().fadeIn(delay: 350.ms).slideY(begin: .1),

                  const Gap(24),

                  ////////////////////////////////////////////////////////////
                  /// Leaderboards
                  ////////////////////////////////////////////////////////////
                  DashboardLeaderboardsWidget(
                    leaderboards: dashboard.leaderboards,
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: .1),

                  const Gap(24),

                  ////////////////////////////////////////////////////////////
                  /// Quick Actions (your existing admin actions)
                  ////////////////////////////////////////////////////////////
                  DashboardQuickActions()
                      .animate()
                      .fadeIn(delay: 500.ms)
                      .slideY(begin: .1),

                  const Gap(32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// Loading State
////////////////////////////////////////////////////////////

class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// Error State
////////////////////////////////////////////////////////////

class _DashboardError extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _DashboardError({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),

            const Gap(16),

            Text(
              "Failed to load dashboard",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const Gap(8),

            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),

            const Gap(16),

            ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }
}
