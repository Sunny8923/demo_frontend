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
/// JOB CARD
///////////////////////////////////////////////////////////////

class _AdminJobCard extends StatelessWidget {
  final JobModel job;

  const _AdminJobCard({required this.job});

  Color statusColor(String? status) {
    if (status == null) return Colors.grey;

    switch (status.toLowerCase()) {
      case "open":
        return Colors.green;
      case "closed":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = statusColor(job.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.withOpacity(.15)),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// Title + Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                _StatusBadge(status: job.status ?? "UNKNOWN", color: color),
              ],
            ),

            const Gap(10),

            /// Company
            Row(
              children: [
                Icon(
                  Icons.business_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),

                const Gap(6),

                Text(job.companyName ?? ""),
              ],
            ),

            const Gap(6),

            /// Location
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),

                const Gap(6),

                Text(job.location ?? ""),
              ],
            ),

            const Gap(12),

            /// Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (job.openings != null)
                  _InfoChip(label: "Openings", value: "${job.openings}"),

                if (job.minExperience != null && job.maxExperience != null)
                  _InfoChip(
                    label: "Experience",
                    value: "${job.minExperience}-${job.maxExperience} yrs",
                  ),

                if (job.salaryMin != null && job.salaryMax != null)
                  _InfoChip(
                    label: "Salary",
                    value: "${job.salaryMin}-${job.salaryMax}",
                  ),
              ],
            ),

            const Gap(12),

            /// Applications
            Row(
              children: [
                Icon(Icons.people_outline, size: 18, color: Colors.grey[700]),

                const Gap(6),

                Text(
                  "${job.applicationsCount ?? 0} Applications",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const Gap(8),

            /// Created date
            Text(
              "Created ${job.createdAt.toLocal().toString().split('.')[0]}",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
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
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

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
    );
  }
}

///////////////////////////////////////////////////////////////
/// INFO CHIP
///////////////////////////////////////////////////////////////

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.08),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Text("$label: $value", style: const TextStyle(fontSize: 12)),
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
