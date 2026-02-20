import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/features/dashboard/partner/presentation/providers/partner_dashboard_provider.dart';
import 'package:gap/gap.dart';

import 'package:frontend/features/partners/presentation/providers/partner_me_provider.dart';

import '../../../../../core/ui/app_scaffold.dart';
import '../../../../../core/ui/stats_card.dart';

import '../../../../application/presentation/screens/my_application_screeen.dart';
import '../../../../auth/presentation/providers/current_user_provider.dart';
import '../../../../jobs/presentation/screens/jobs_list_screen.dart';

class PartnerDashboardScreen extends ConsumerWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final partner = ref.watch(partnerMeProvider).value;

    ref.listen(currentUserProvider, (previous, next) {
      final previousId = previous?.value?.id;
      final nextId = next.value?.id;

      if (previousId != null && nextId != null && previousId != nextId) {
        print("DEBUG: User changed → invalidate partnerDashboardProvider");

        ref.invalidate(partnerDashboardProvider);
      }
    });

    final dashboardState = ref.watch(partnerDashboardProvider);

    final theme = Theme.of(context);

    return AppScaffold(
      title: "Partner Dashboard",

      body: RefreshIndicator(
        onRefresh: () async {
          print("DEBUG: Partner dashboard refresh");

          await ref.read(partnerDashboardProvider.notifier).refresh();
        },

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ////////////////////////////////////////////////////////////
              /// Welcome section
              ////////////////////////////////////////////////////////////
              _WelcomeSection(
                name: user?.name ?? "",
                status: partner?.status ?? "UNKNOWN",
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),

              const Gap(24),

              ////////////////////////////////////////////////////////////
              /// Stats section (CONNECTED TO BACKEND)
              ////////////////////////////////////////////////////////////
              dashboardState.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),

                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Failed to load dashboard",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                data: (dashboard) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            title: "Candidates",
                            value: dashboard.candidatesSubmitted.toString(),
                            icon: Icons.people_outline,
                          ),
                        ),

                        const Gap(12),

                        Expanded(
                          child: StatsCard(
                            title: "Applications",
                            value: dashboard.applicationsSubmitted.toString(),
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
                            title: "Active",
                            value: dashboard.activeApplications.toString(),
                            icon: Icons.timelapse,
                          ),
                        ),

                        const Gap(12),

                        Expanded(
                          child: StatsCard(
                            title: "Hired",
                            value: dashboard.hiredApplications.toString(),
                            icon: Icons.check_circle_outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ).animate().fadeIn(delay: 150.ms).slideY(begin: .15),
              ),

              const Gap(32),

              ////////////////////////////////////////////////////////////
              /// Actions
              ////////////////////////////////////////////////////////////
              Text(
                "Partner Actions",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(delay: 250.ms),

              const Gap(16),

              _PartnerActionCard(
                icon: Icons.work_outline,
                title: "Browse Jobs",
                subtitle: "View available opportunities",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JobsListScreen()),
                  );
                },
              ).animate().fadeIn(delay: 300.ms).slideX(begin: .1),

              const Gap(12),

              _PartnerActionCard(
                icon: Icons.person_add_alt_1,
                title: "Submit Candidate",
                subtitle: "Apply candidate to a job",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JobsListScreen()),
                  );
                },
              ).animate().fadeIn(delay: 350.ms).slideX(begin: .1),

              const Gap(12),

              _PartnerActionCard(
                icon: Icons.assignment_outlined,
                title: "My Submissions",
                subtitle: "Track submitted candidates",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyApplicationsScreen(),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 400.ms).slideX(begin: .1),

              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// WELCOME SECTION
///////////////////////////////////////////////////////////////

class _WelcomeSection extends StatelessWidget {
  final String name;
  final String status;

  const _WelcomeSection({required this.name, required this.status});

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

        const Gap(10),

        _StatusBadge(status: status),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////
/// ACTION CARD
///////////////////////////////////////////////////////////////

class _PartnerActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PartnerActionCard({
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
/// STATUS BADGE
///////////////////////////////////////////////////////////////

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case "APPROVED":
        color = Colors.green;
        break;
      case "PENDING":
        color = Colors.orange;
        break;
      case "REJECTED":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(.9, .9));
  }
}
