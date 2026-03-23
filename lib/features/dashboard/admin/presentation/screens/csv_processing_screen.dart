import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/job_status_provider.dart';

class CsvProcessingScreen extends ConsumerStatefulWidget {
  final String jobId;

  const CsvProcessingScreen({super.key, required this.jobId});

  @override
  ConsumerState<CsvProcessingScreen> createState() =>
      _CsvProcessingScreenState();
}

class _CsvProcessingScreenState extends ConsumerState<CsvProcessingScreen> {
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
      appBar: AppBar(title: const Text("Processing CSV")),

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
                final isCompleted = data.completed;

                ////////////////////////////////////////////////////////////
                /// PROCESSING STATE
                ////////////////////////////////////////////////////////////
                if (!isCompleted) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Gap(20),
                      Text(
                        "Processing your CSV file...",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }

                ////////////////////////////////////////////////////////////
                /// COMPLETED STATE
                ////////////////////////////////////////////////////////////

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ////////////////////////////////////////////////////////////
                    /// HEADER
                    ////////////////////////////////////////////////////////////
                    Text(
                      "CSV Processed Successfully",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const Gap(24),

                    ////////////////////////////////////////////////////////////
                    /// STATS
                    ////////////////////////////////////////////////////////////
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _StatCard(label: "Total", value: data.total.toString()),
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
                    /// BUTTONS
                    ////////////////////////////////////////////////////////////
                    Column(
                      children: [
                        ////////////////////////////////////////////////////////////
                        /// VIEW CANDIDATES
                        ////////////////////////////////////////////////////////////
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/candidates", // 👈 your existing route
                              );
                            },
                            child: const Text("View Candidates"),
                          ),
                        ),

                        const Gap(10),

                        ////////////////////////////////////////////////////////////
                        /// CLOSE
                        ////////////////////////////////////////////////////////////
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
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
  final Color? color;

  const _StatCard({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.grey;

    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: c.withOpacity(.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: c,
            ),
          ),
          const Gap(6),
          Text(label),
        ],
      ),
    );
  }
}
