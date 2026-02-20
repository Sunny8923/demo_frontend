import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/core/ui/app_scaffold.dart';
import 'package:frontend/core/ui/stats_card.dart';
import 'package:frontend/features/application/presentation/screens/my_application_screeen.dart';
import 'package:frontend/features/auth/presentation/providers/current_user_provider.dart';
import 'package:frontend/features/jobs/presentation/screens/jobs_list_screen.dart';
import 'package:gap/gap.dart';

import '../providers/user_dashboard_provider.dart';

class UserDashboardScreen extends ConsumerWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final dashboardState = ref.watch(userDashboardProvider);
    final theme = Theme.of(context);

    return AppScaffold(
      title: "Dashboard",

      body: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Text(
            "Failed to load dashboard",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),

        data: (dashboard) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(userDashboardProvider.notifier).refresh();
            },

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  //////////////////////////////////////////////////////
                  /// Welcome
                  //////////////////////////////////////////////////////
                  _WelcomeSection(
                    name: user?.name ?? "",
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),

                  const Gap(24),

                  //////////////////////////////////////////////////////
                  /// Stats row 1
                  //////////////////////////////////////////////////////
                  Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          title: "Applications",
                          value: dashboard.totalApplications.toString(),
                          icon: Icons.assignment_outlined,
                        ),
                      ),

                      const Gap(12),

                      Expanded(
                        child: StatsCard(
                          title: "Active",
                          value: dashboard.activeApplications.toString(),
                          icon: Icons.pending_actions_outlined,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 150.ms).slideY(begin: .15),

                  const Gap(12),

                  //////////////////////////////////////////////////////
                  /// Stats row 2
                  //////////////////////////////////////////////////////
                  Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          title: "Hired",
                          value: dashboard.hiredApplications.toString(),
                          icon: Icons.check_circle_outline,
                        ),
                      ),

                      const Gap(12),

                      Expanded(
                        child: StatsCard(
                          title: "Rejected",
                          value: dashboard.rejectedApplications.toString(),
                          icon: Icons.cancel_outlined,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: .15),

                  const Gap(32),

                  //////////////////////////////////////////////////////
                  /// Quick actions title
                  //////////////////////////////////////////////////////
                  Text(
                    "Quick Actions",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate().fadeIn(delay: 250.ms),

                  const Gap(16),

                  //////////////////////////////////////////////////////
                  /// Browse Jobs
                  //////////////////////////////////////////////////////
                  _DashboardActionCard(
                    icon: Icons.work_outline,
                    title: "Browse Jobs",
                    subtitle: "Explore available opportunities",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JobsListScreen(),
                        ),
                      );
                    },
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: .1),

                  const Gap(12),

                  //////////////////////////////////////////////////////
                  /// My Applications
                  //////////////////////////////////////////////////////
                  _DashboardActionCard(
                    icon: Icons.assignment_outlined,
                    title: "My Applications",
                    subtitle: "Track your job applications",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyApplicationsScreen(),
                        ),
                      );
                    },
                  ).animate().fadeIn(delay: 350.ms).slideX(begin: .1),

                  const Gap(24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// WELCOME SECTION
///////////////////////////////////////////////////////////////

class _WelcomeSection extends StatelessWidget {
  final String name;

  const _WelcomeSection({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back,",
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),

        const Gap(4),

        Text(
          name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////
/// ACTION CARD
///////////////////////////////////////////////////////////////

class _DashboardActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DashboardActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.withOpacity(.15)),
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(icon, color: theme.colorScheme.primary),
              ),

              const Gap(16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),

                    const Gap(4),

                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),

              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
