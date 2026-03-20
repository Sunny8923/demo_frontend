import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/job_status_provider.dart';

class JobStatusScreen extends ConsumerStatefulWidget {
  final String jobId;

  const JobStatusScreen({super.key, required this.jobId});

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
      ref.read(jobStatusProvider.notifier).start(widget.jobId);
    });
  }

  ////////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobStatusProvider);
    final theme = Theme.of(context);

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
                if (data.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final progress = data["progress"] ?? {};
                final stats = data["stats"] ?? {};
                final activity = data["activity"] ?? {};
                final summary = data["summary"] ?? {};

                final percentage = progress["percentage"] ?? 0;
                final isCompleted = summary["completed"] == true;

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
                      value: (percentage as num).toDouble() / 100,
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
                      activity["currentFile"] ?? "-",
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
                          value: (stats["created"] ?? 0).toString(),
                          color: Colors.green,
                        ),
                        _StatCard(
                          label: "Duplicate",
                          value: (stats["duplicate"] ?? 0).toString(),
                          color: Colors.orange,
                        ),
                        _StatCard(
                          label: "Errors",
                          value: (stats["error"] ?? 0).toString(),
                          color: Colors.red,
                        ),
                      ],
                    ),

                    const Spacer(),

                    ////////////////////////////////////////////////////////////
                    /// DONE BUTTON
                    ////////////////////////////////////////////////////////////
                    if (isCompleted)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Done"),
                        ),
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
