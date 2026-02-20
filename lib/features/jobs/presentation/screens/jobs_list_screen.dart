import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../../../../core/ui/app_scaffold.dart';

import '../../../application/presentation/screens/submit_candidate_screen.dart';
import '../../data/models/job_model.dart';
import '../providers/jobs_provider.dart';

class JobsListScreen extends ConsumerWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsState = ref.watch(jobsProvider);

    return AppScaffold(
      title: "Jobs",

      body: jobsState.when(
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

                return _JobCard(job: job)
                    .animate()
                    .fadeIn(delay: (index * 50).ms, duration: 300.ms)
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

class _JobCard extends StatelessWidget {
  final JobModel job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.withOpacity(.15)),
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SubmitCandidateScreen(job: job)),
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// Title
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

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),

              const Gap(8),

              /// Company
              Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),

                  const Gap(6),

                  Text(
                    job.companyName ?? "",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
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

                  Text(
                    job.location ?? "",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),

              const Gap(10),

              /// Created by + Apply button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Created by ${job.createdByName ?? "Admin"}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ),

                  _ApplyButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// APPLY BUTTON
///////////////////////////////////////////////////////////////

class _ApplyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(.1),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        "Apply",
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
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
      child: Text(
        "No jobs available",
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
