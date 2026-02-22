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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(adminDashboardProvider);

    final currentUser = ref.watch(currentUserProvider).value;

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
            onRetry: () => ref.read(adminDashboardProvider.notifier).refresh(),
          ),

          data: (dashboard) {
            return DefaultTabController(
              length: 4,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  ////////////////////////////////////////////////////////////
                  /// SCROLLABLE TOP SECTION
                  ////////////////////////////////////////////////////////////
                  Expanded(
                    child: NestedScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),

                      headerSliverBuilder: (context, innerBoxScrolled) {
                        return [
                          ////////////////////////////////////////////////////
                          /// HEADER
                          ////////////////////////////////////////////////////
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),

                              child:
                                  DashboardHeader(
                                        adminName: currentUser?.name ?? "Admin",
                                        range: dashboard.range,
                                      )
                                      .animate()
                                      .fadeIn(duration: 400.ms)
                                      .slideY(begin: .2),
                            ),
                          ),

                          ////////////////////////////////////////////////////
                          /// SUMMARY CARDS
                          ////////////////////////////////////////////////////
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16),

                              child:
                                  DashboardSummaryCards(
                                        summary: dashboard.summary,
                                        summaryChange: dashboard.summaryChange,
                                      )
                                      .animate()
                                      .fadeIn(delay: 100.ms)
                                      .slideY(begin: .1),
                            ),
                          ),

                          ////////////////////////////////////////////////////
                          /// PREMIUM TAB BAR
                          ////////////////////////////////////////////////////
                          SliverPersistentHeader(
                            pinned: true,

                            delegate: _PremiumTabBarDelegate(
                              TabBar(
                                isScrollable: true,

                                labelStyle: theme.textTheme.labelLarge,

                                indicatorColor: scheme.primary,

                                indicatorWeight: 2.5,

                                labelColor: scheme.primary,

                                unselectedLabelColor: scheme.onSurfaceVariant,

                                tabs: const [
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
                      /// TAB CONTENT
                      ////////////////////////////////////////////////////////////
                      body: TabBarView(
                        children: [
                          ////////////////////////////////////////////////////
                          /// ACTIONS TAB
                          ////////////////////////////////////////////////////
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),

                            child: DashboardQuickActions()
                                .animate()
                                .fadeIn()
                                .slideY(begin: .1),
                          ),
                          ////////////////////////////////////////////////////
                          /// OVERVIEW TAB
                          ////////////////////////////////////////////////////
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),

                            child: DashboardPipelineWidget(
                              pipeline: dashboard.pipeline,
                            ).animate().fadeIn().slideY(begin: .1),
                          ),

                          ////////////////////////////////////////////////////
                          /// ANALYTICS TAB
                          ////////////////////////////////////////////////////
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),

                            child: Column(
                              children: [
                                DashboardTrendsChart(trends: dashboard.trends),

                                const Gap(24),

                                AdminDistributionChart(
                                  distribution: dashboard.distribution,
                                ),
                              ],
                            ).animate().fadeIn().slideY(begin: .1),
                          ),

                          ////////////////////////////////////////////////////
                          /// LEADERBOARDS TAB
                          ////////////////////////////////////////////////////
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),

                            child: DashboardLeaderboardsWidget(
                              leaderboards: dashboard.leaderboards,
                            ).animate().fadeIn().slideY(begin: .1),
                          ),
                        ],
                      ),
                    ),
                  ),
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
/// PREMIUM TAB BAR DELEGATE
////////////////////////////////////////////////////////////

class _PremiumTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _PremiumTabBarDelegate(this.tabBar);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      color: scheme.surface,

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
/// Loading
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
/// Error
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
