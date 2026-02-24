import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../../../../core/ui/app_scaffold.dart';

import '../../data/models/job_model.dart';
import '../providers/jobs_provider.dart';

class AdminJobsScreen extends ConsumerWidget {
  const AdminJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobsProvider);

    return AppScaffold(
      title: "All Jobs",

      body: state.when(
        loading: () => const _LoadingState(),

        error: (e, _) => _ErrorState(message: e.toString()),

        data: (jobs) {
          if (jobs.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(jobsProvider.notifier).refresh(),

            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),

              itemCount: jobs.length,

              itemBuilder: (context, index) {
                final job = jobs[index];

                return _AdminJobCard(job: job)
                    .animate()
                    .fadeIn(delay: (index * 40).ms, duration: 300.ms)
                    .slideY(begin: .05);
              },
            ),
          );
        },
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// PREMIUM JOB CARD
///////////////////////////////////////////////////////////////

class _AdminJobCard extends StatelessWidget {
  final JobModel job;

  const _AdminJobCard({required this.job});

  Color statusColor(String? status) {
    if (status == null) return const Color(0xFF64748B);

    switch (status.toLowerCase()) {
      case "open":
        return const Color(0xFF059669); // muted emerald

      case "closed":
        return const Color(0xFFDC2626); // muted red

      default:
        return const Color(0xFFD97706); // muted amber
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = statusColor(job.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        gradient: LinearGradient(
          colors: [theme.colorScheme.surface, color.withOpacity(.035)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        border: Border.all(color: color.withOpacity(.18)),

        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),

        child: Row(
          children: [
            ////////////////////////////////////////////////////////////
            /// LEFT ACCENT BAR
            ////////////////////////////////////////////////////////////
            Container(
              width: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(.6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            ////////////////////////////////////////////////////////////
            /// CONTENT
            ////////////////////////////////////////////////////////////
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    ////////////////////////////////////////////////////////////
                    /// TITLE + STATUS
                    ////////////////////////////////////////////////////////////
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            job.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -.2,
                            ),
                          ),
                        ),

                        _StatusBadge(
                          status: job.status ?? "UNKNOWN",
                          color: color,
                        ),
                      ],
                    ),

                    const Gap(12),

                    ////////////////////////////////////////////////////////////
                    /// COMPANY
                    ////////////////////////////////////////////////////////////
                    _MutedRow(
                      icon: Icons.business_outlined,
                      text: job.companyName ?? "",
                    ),

                    const Gap(6),

                    ////////////////////////////////////////////////////////////
                    /// LOCATION
                    ////////////////////////////////////////////////////////////
                    _MutedRow(
                      icon: Icons.location_on_outlined,
                      text: job.location ?? "",
                    ),

                    const Gap(14),

                    ////////////////////////////////////////////////////////////
                    /// PREMIUM CHIPS
                    ////////////////////////////////////////////////////////////
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,

                      children: [
                        if (job.openings != null)
                          _PremiumChip(
                            icon: Icons.groups_outlined,
                            text: "${job.openings} openings",
                            color: const Color(0xFF2563EB),
                          ),

                        if (job.minExperience != null &&
                            job.maxExperience != null)
                          _PremiumChip(
                            icon: Icons.work_outline,
                            text:
                                "${job.minExperience}-${job.maxExperience} yrs",
                            color: const Color(0xFF7C3AED),
                          ),

                        if (job.salaryMin != null && job.salaryMax != null)
                          _PremiumChip(
                            icon: Icons.currency_rupee,
                            text: "${job.salaryMin}-${job.salaryMax}",
                            color: const Color(0xFF059669),
                          ),
                      ],
                    ),

                    const Gap(14),

                    ////////////////////////////////////////////////////////////
                    /// APPLICATIONS
                    ////////////////////////////////////////////////////////////
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 18,
                          color: color.withOpacity(.85),
                        ),

                        const Gap(6),

                        Text(
                          "${job.applicationsCount ?? 0} Applications",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: color.withOpacity(.9),
                          ),
                        ),
                      ],
                    ),

                    const Gap(8),

                    ////////////////////////////////////////////////////////////
                    /// CREATED DATE
                    ////////////////////////////////////////////////////////////
                    Text(
                      "Created ${job.createdAt.toLocal().toString().split('.')[0]}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// MUTED ROW
///////////////////////////////////////////////////////////////

class _MutedRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MutedRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),

        const Gap(6),

        Text(
          text,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////
/// STATUS BADGE
///////////////////////////////////////////////////////////////

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),

      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// PREMIUM CHIP
///////////////////////////////////////////////////////////////

class _PremiumChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _PremiumChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: color.withOpacity(.18)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, size: 14, color: color),

          const Gap(5),

          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(.9),
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// STATES
///////////////////////////////////////////////////////////////

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.red)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("No jobs found", style: TextStyle(color: Colors.grey[600])),
    );
  }
}
