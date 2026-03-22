import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/features/dashboard/admin/presentation/widgets/dashboard_pipeline.dart';
import 'package:gap/gap.dart';

import '../../../../auth/presentation/providers/current_user_provider.dart';
import '../providers/admin_dashboard_provider.dart';

import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_summary_cards.dart';
import '../widgets/dashboard_trends_chart.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/resume_job_banner.dart';
import '../widgets/dashboard_distribution_chart.dart';
import '../widgets/dashboard_leaderboards.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    await ref.read(adminDashboardProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(adminDashboardProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    return dashboardState.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (error, _) => _DashboardError(
        error: error.toString(),
        onRetry: () => _refresh(ref),
      ),

      data: (dashboard) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;

            return RefreshIndicator(
              onRefresh: () => _refresh(ref),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ////////////////////////////////////////////////////
                        /// HEADER
                        ////////////////////////////////////////////////////
                        DashboardHeader(
                          adminName: currentUser?.name ?? "Admin",
                        ).animate().fadeIn().slideY(begin: .2),

                        const Gap(16),

                        ////////////////////////////////////////////////////
                        /// SUMMARY
                        ////////////////////////////////////////////////////
                        DashboardSummaryCards(
                          summary: dashboard.summary,
                          summaryChange: dashboard.summaryChange,
                        ).animate().fadeIn(delay: 100.ms),

                        const Gap(24),

                        ////////////////////////////////////////////////////
                        /// MAIN GRID
                        ////////////////////////////////////////////////////
                        if (!isDesktop)
                          Column(
                            children: [
                              _Card(
                                child: DashboardTrendsChart(
                                  trends: dashboard.trends,
                                ),
                              ),
                              const Gap(16),

                              _Card(
                                child: DashboardPipelineWidget(
                                  pipeline: dashboard.pipeline,
                                ),
                              ),
                              const Gap(16),

                              _Card(child: DashboardQuickActions()),
                              const Gap(16),

                              const ResumeJobBanner(),
                            ],
                          )
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //////////////////////////////////////////////////
                              /// LEFT SIDE
                              //////////////////////////////////////////////////
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _Card(
                                      child: DashboardTrendsChart(
                                        trends: dashboard.trends,
                                      ),
                                    ),
                                    const Gap(16),

                                    _Card(
                                      child: DashboardPipelineWidget(
                                        pipeline: dashboard.pipeline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Gap(24),

                              //////////////////////////////////////////////////
                              /// RIGHT SIDE
                              //////////////////////////////////////////////////
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    _Card(child: DashboardQuickActions()),
                                    const Gap(16),

                                    const ResumeJobBanner(),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ////////////////////////////////////////////////////
                        /// ANALYTICS SECTION (NEW)
                        ////////////////////////////////////////////////////
                        const Gap(24),

                        const Text(
                          "Analytics Overview",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),

                        const Gap(12),

                        if (!isDesktop)
                          Column(
                            children: [
                              _Card(
                                child: AdminDistributionChart(
                                  distribution: dashboard.distribution,
                                ),
                              ),
                              const Gap(16),

                              _Card(
                                child: DashboardLeaderboardsWidget(
                                  leaderboards: dashboard.leaderboards,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _Card(
                                  child: AdminDistributionChart(
                                    distribution: dashboard.distribution,
                                  ),
                                ),
                              ),

                              const Gap(24),

                              Expanded(
                                child: _Card(
                                  child: DashboardLeaderboardsWidget(
                                    leaderboards: dashboard.leaderboards,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// CARD WRAPPER
////////////////////////////////////////////////////////////

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 10),
        ],
      ),
      child: child,
    );
  }
}

////////////////////////////////////////////////////////////
/// ERROR
////////////////////////////////////////////////////////////

class _DashboardError extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _DashboardError({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const Gap(16),
          const Text("Failed to load dashboard"),
          const Gap(8),
          Text(error),
          const Gap(16),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
