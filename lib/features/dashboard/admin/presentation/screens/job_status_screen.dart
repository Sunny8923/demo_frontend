import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/shared/current_job_provider.dart';
import 'package:frontend/features/dashboard/admin/presentation/screens/resume_result_screen.dart';
import 'package:gap/gap.dart';

import '../providers/job_status_provider.dart';

class JobStatusScreen extends ConsumerStatefulWidget {
  final String? jobId;

  const JobStatusScreen({super.key, this.jobId});

  @override
  ConsumerState<JobStatusScreen> createState() => _JobStatusScreenState();
}

class _JobStatusScreenState extends ConsumerState<JobStatusScreen> {
  ////////////////////////////////////////////////////////////
  /// INIT → START POLLING
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final globalJobId = ref.read(currentJobProvider);
      final idToUse = widget.jobId ?? globalJobId;

      if (idToUse != null) {
        ref.read(jobStatusProvider.notifier).start(idToUse);
      }
    });
  }

  ////////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobStatusProvider);
    final theme = Theme.of(context);

    final globalJobId = ref.watch(currentJobProvider);

    ////////////////////////////////////////////////////////////
    /// NO JOB CASE
    ////////////////////////////////////////////////////////////

    if (widget.jobId == null && globalJobId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Processing Resumes")),
        body: const Center(child: Text("No active job found")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Processing Resumes")),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: state.when(
              ////////////////////////////////////////////////////////////
              /// LOADING
              ////////////////////////////////////////////////////////////
              loading: () => const Center(child: CircularProgressIndicator()),

              ////////////////////////////////////////////////////////////
              /// ERROR
              ////////////////////////////////////////////////////////////
              error: (e, _) => Center(child: Text("Error: $e")),

              ////////////////////////////////////////////////////////////
              /// DATA
              ////////////////////////////////////////////////////////////
              data: (data) {
                final percentage = data.percentage;
                final isCompleted = data.completed;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ////////////////////////////////////////////////////////////
                    /// HEADER
                    ////////////////////////////////////////////////////////////
                    Text(
                      isCompleted
                          ? "Upload Completed"
                          : "Processing Resumes...",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const Gap(20),

                    ////////////////////////////////////////////////////////////
                    /// PROGRESS BAR
                    ////////////////////////////////////////////////////////////
                    LinearProgressIndicator(
                      value: percentage / 100,
                      minHeight: 10,
                    ),

                    const Gap(10),

                    Text("$percentage% completed"),

                    const Gap(24),

                    ////////////////////////////////////////////////////////////
                    /// CURRENT FILE
                    ////////////////////////////////////////////////////////////
                    Text("Current File", style: theme.textTheme.titleMedium),

                    const Gap(6),

                    Text(
                      data.currentFile.isEmpty ? "-" : data.currentFile,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const Gap(24),

                    ////////////////////////////////////////////////////////////
                    /// STATS
                    ////////////////////////////////////////////////////////////
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _StatCard(
                          label: "Created",
                          value: data.created.toString(),
                          color: Colors.green,
                        ),
                        _StatCard(
                          label: "Duplicate",
                          value: data.duplicate.toString(),
                          color: Colors.orange,
                        ),
                        _StatCard(
                          label: "Skipped",
                          value: data.skipped.toString(),
                          color: Colors.blue,
                        ),
                        _StatCard(
                          label: "Errors",
                          value: data.error.toString(),
                          color: Colors.red,
                        ),
                      ],
                    ),

                    const Spacer(),

                    ////////////////////////////////////////////////////////////
                    /// ACTION BUTTONS
                    ////////////////////////////////////////////////////////////
                    if (isCompleted)
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ResumeResultScreen(
                                      result: data.rawResponse,
                                    ),
                                  ),
                                );
                              },
                              child: const Text("View Results"),
                            ),
                          ),

                          const Gap(10),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                ref.read(currentJobProvider.notifier).clear();

                                Navigator.pop(context);
                              },
                              child: const Text("Close"),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// STAT CARD
////////////////////////////////////////////////////////////

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(.1),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const Gap(6),
          Text(label),
        ],
      ),
    );
  }
}
