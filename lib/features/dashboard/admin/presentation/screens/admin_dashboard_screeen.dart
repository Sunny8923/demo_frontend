import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../../../../../core/ui/app_scaffold.dart';

import '../../../../auth/presentation/providers/current_user_provider.dart';
import '../providers/admin_dashboard_provider.dart';

import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_summary_cards.dart';
import '../widgets/dashboard_pipeline.dart';
import '../widgets/dashboard_trends_chart.dart';
import '../widgets/dashboard_distribution_chart.dart';
import '../widgets/dashboard_leaderboards.dart';
import '../widgets/dashboard_quick_actions.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    await ref.read(adminDashboardProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(adminDashboardProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    return AppScaffold(
      title: "Admin Dashboard",
      body: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => _DashboardError(
          error: error.toString(),
          onRetry: () => _refresh(ref),
        ),

        data: (dashboard) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;

              ////////////////////////////////////////////////////////////
              /// DESKTOP DASHBOARD
              ////////////////////////////////////////////////////////////

              if (isDesktop) {
                return RefreshIndicator(
                  onRefresh: () => _refresh(ref),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1400),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ////////////////////////////////////////////////////
                            /// HEADER
                            ////////////////////////////////////////////////////
                            DashboardHeader(
                              adminName: currentUser?.name ?? "Admin",
                            ).animate().fadeIn().slideY(begin: .2),

                            const Gap(24),

                            ////////////////////////////////////////////////////
                            /// SUMMARY + QUICK ACTIONS
                            ////////////////////////////////////////////////////
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child:
                                      DashboardSummaryCards(
                                            summary: dashboard.summary,
                                            summaryChange:
                                                dashboard.summaryChange,
                                          )
                                          .animate()
                                          .fadeIn(delay: 100.ms)
                                          .slideY(begin: .1),
                                ),
                                const Gap(24),
                                Expanded(
                                  flex: 1,
                                  child: DashboardQuickActions(),
                                ),
                              ],
                            ),

                            const Gap(32),

                            ////////////////////////////////////////////////////
                            /// HERO CHART
                            ////////////////////////////////////////////////////
                            DashboardTrendsChart(trends: dashboard.trends),

                            const Gap(32),

                            ////////////////////////////////////////////////////
                            /// PIPELINE + DISTRIBUTION
                            ////////////////////////////////////////////////////
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: DashboardPipelineWidget(
                                    pipeline: dashboard.pipeline,
                                  ),
                                ),
                                const Gap(24),
                                Expanded(
                                  flex: 1,
                                  child: AdminDistributionChart(
                                    distribution: dashboard.distribution,
                                  ),
                                ),
                              ],
                            ),

                            const Gap(32),

                            ////////////////////////////////////////////////////
                            /// LEADERBOARDS
                            ////////////////////////////////////////////////////
                            DashboardLeaderboardsWidget(
                              leaderboards: dashboard.leaderboards,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              ////////////////////////////////////////////////////////////
              /// MOBILE DASHBOARD (UNCHANGED)
              ////////////////////////////////////////////////////////////

              return DefaultTabController(
                length: 4,
                child: NestedScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  ////////////////////////////////////////////////////////////
                  /// HEADER
                  ////////////////////////////////////////////////////////////
                  headerSliverBuilder: (context, innerBoxScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child:
                              DashboardHeader(
                                    adminName: currentUser?.name ?? "Admin",
                                  )
                                  .animate()
                                  .fadeIn(duration: 400.ms)
                                  .slideY(begin: .2),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: DashboardSummaryCards(
                            summary: dashboard.summary,
                            summaryChange: dashboard.summaryChange,
                          ).animate().fadeIn(delay: 100.ms).slideY(begin: .1),
                        ),
                      ),

                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _PremiumTabBarDelegate(
                          const TabBar(
                            isScrollable: true,
                            tabs: [
                              Tab(text: "Actions"),
                              Tab(text: "Overview"),
                              Tab(text: "Analytics"),
                              Tab(text: "Leaderboards"),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },

                  ////////////////////////////////////////////////////////////
                  /// MOBILE TAB CONTENT
                  ////////////////////////////////////////////////////////////
                  body: TabBarView(
                    children: [
                      _RefreshableTab(
                        onRefresh: () => _refresh(ref),
                        child: DashboardQuickActions(),
                      ),

                      _RefreshableTab(
                        onRefresh: () => _refresh(ref),
                        child: DashboardPipelineWidget(
                          pipeline: dashboard.pipeline,
                        ),
                      ),

                      _RefreshableTab(
                        onRefresh: () => _refresh(ref),
                        child: Column(
                          children: [
                            DashboardTrendsChart(trends: dashboard.trends),
                            const Gap(24),
                            AdminDistributionChart(
                              distribution: dashboard.distribution,
                            ),
                          ],
                        ),
                      ),

                      _RefreshableTab(
                        onRefresh: () => _refresh(ref),
                        child: DashboardLeaderboardsWidget(
                          leaderboards: dashboard.leaderboards,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// REFRESHABLE TAB
////////////////////////////////////////////////////////////

class _RefreshableTab extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const _RefreshableTab({required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: child.animate().fadeIn().slideY(begin: .1),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// TAB BAR DELEGATE
////////////////////////////////////////////////////////////

class _PremiumTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _PremiumTabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => 52;

  @override
  double get minExtent => 52;

  @override
  bool shouldRebuild(_) => false;
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
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
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
