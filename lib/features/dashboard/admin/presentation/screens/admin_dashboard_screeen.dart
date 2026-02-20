import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/features/application/presentation/screens/ats_pipeline_screen.dart';
import 'package:frontend/features/dashboard/admin/presentation/providers/admin_dashboard_provider.dart';
import 'package:gap/gap.dart';

import '../../../../../core/ui/app_scaffold.dart';
import '../../../../../core/ui/stats_card.dart';

import '../../../../auth/presentation/providers/current_user_provider.dart';
import '../../../../jobs/presentation/screens/admin_jobs_screen.dart';
import '../../../../jobs/presentation/screens/create_single_job_screen.dart';
import '../../../../jobs/presentation/screens/upload_csv_screen.dart';
import '../../../../partners/presentation/screens/pending_partner_screen.dart';
import '../../../../application/presentation/screens/admin_application_screeen.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final statsState = ref.watch(adminDashboardProvider);

    final theme = Theme.of(context);

    return AppScaffold(
      title: "Admin Dashboard",

      body: RefreshIndicator(
        onRefresh: () async {
          print("DEBUG: Pull-to-refresh triggered");

          await ref.read(adminDashboardProvider.notifier).refresh();
        },

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Welcome section
              _WelcomeSection(
                name: user?.name ?? "Admin",
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),

              const Gap(24),

              /////////////////////////////////////////////////////////////////
              /// Stats cards (LIVE DATA)
              /////////////////////////////////////////////////////////////////
              statsState.when(
                loading: () => Column(
                  children: const [
                    Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            title: "Total Jobs",
                            value: "...",
                            icon: Icons.work_outline,
                          ),
                        ),
                        Gap(12),
                        Expanded(
                          child: StatsCard(
                            title: "Applications",
                            value: "...",
                            icon: Icons.assignment_outlined,
                          ),
                        ),
                      ],
                    ),
                    Gap(12),
                    Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            title: "Total Partners",
                            value: "...",
                            icon: Icons.groups_outlined,
                          ),
                        ),
                        Gap(12),
                        Expanded(
                          child: StatsCard(
                            title: "Pending Approval",
                            value: "...",
                            icon: Icons.pending_actions_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                error: (_, _) => const SizedBox(),

                data: (stats) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            title: "Total Jobs",
                            value: stats.totalJobs.toString(),
                            icon: Icons.work_outline,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: StatsCard(
                            title: "Applications",
                            value: stats.totalApplications.toString(),
                            icon: Icons.assignment_outlined,
                          ),
                        ),
                      ],
                    ),

                    const Gap(12),

                    Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            title: "Total Partners",
                            value: stats.totalPartners.toString(),
                            icon: Icons.groups_outlined,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: StatsCard(
                            title: "Pending Approval",
                            value: stats.pendingPartners.toString(),
                            icon: Icons.pending_actions_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Gap(32),

              /// Section title
              Text(
                "Admin Actions",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(delay: 250.ms),

              const Gap(16),

              /// Create Job
              _AdminActionCard(
                icon: Icons.add_box_outlined,
                title: "Create Job",
                subtitle: "Create single job or upload CSV",
                onTap: () => _showCreateJobSheet(context),
              ).animate().fadeIn(delay: 300.ms).slideX(begin: .1),

              const Gap(12),

              /// Approve Partners
              _AdminActionCard(
                icon: Icons.verified_user_outlined,
                title: "Approve Partners",
                subtitle: "Review and approve partner accounts",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PendingPartnerScreen(),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 350.ms).slideX(begin: .1),

              const Gap(12),

              /// View Jobs
              _AdminActionCard(
                icon: Icons.work_outline,
                title: "View Jobs",
                subtitle: "See all created jobs",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminJobsScreen()),
                  );
                },
              ).animate().fadeIn(delay: 400.ms).slideX(begin: .1),

              const Gap(12),

              /// View Applications
              _AdminActionCard(
                icon: Icons.assignment_outlined,
                title: "View Applications",
                subtitle: "Review candidate applications",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminApplicationsScreen(),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 450.ms).slideX(begin: .1),

              const Gap(12),

              /// ATS Pipeline
              _AdminActionCard(
                icon: Icons.account_tree_outlined,
                title: "ATS Pipeline",
                subtitle: "Manage candidate pipeline",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AtsPipelineScreen(),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 500.ms).slideX(begin: .1),

              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// CREATE JOB SHEET
  /////////////////////////////////////////////////////////////

  void _showCreateJobSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Create Job",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Gap(20),

              _SheetOption(
                icon: Icons.add_box_outlined,
                title: "Create Single Job",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateSingleJobScreen(),
                    ),
                  );
                },
              ),

              _SheetOption(
                icon: Icons.upload_file_outlined,
                title: "Upload CSV",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UploadCsvScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

///////////////////////////////////////////////////////////////
/// Welcome Section
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
/// ADMIN ACTION CARD
///////////////////////////////////////////////////////////////

class _AdminActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminActionCard({
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

///////////////////////////////////////////////////////////////
/// SHEET OPTION
///////////////////////////////////////////////////////////////

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onTap,
    );
  }
}
