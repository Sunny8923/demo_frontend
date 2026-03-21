import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/shared/current_job_provider.dart';
import 'package:frontend/features/dashboard/admin/presentation/providers/job_status_provider.dart';
import 'package:frontend/features/dashboard/admin/presentation/screens/job_status_screen.dart';

class ResumeJobBanner extends ConsumerWidget {
  const ResumeJobBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobId = ref.watch(currentJobProvider);

    ////////////////////////////////////////////////////////////
    /// START POLLING
    ////////////////////////////////////////////////////////////
    if (jobId != null) {
      Future.microtask(() {
        ref.read(jobStatusProvider.notifier).start(jobId);
      });
    }

    final jobState = ref.watch(jobStatusProvider);

    if (jobId == null) return const SizedBox();

    ////////////////////////////////////////////////////////////
    /// EXTRACT DATA (MODEL BASED)
    ////////////////////////////////////////////////////////////

    int percentage = 0;
    int processed = 0;
    int total = 0;
    bool isCompleted = false;

    jobState.whenOrNull(
      data: (data) {
        percentage = data.percentage;
        processed = data.processed;
        total = data.total;
        isCompleted = data.completed;
      },
    );

    ////////////////////////////////////////////////////////////
    /// UI
    ////////////////////////////////////////////////////////////

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withOpacity(.08)
            : Colors.blue.withOpacity(.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withOpacity(.3)
              : Colors.blue.withOpacity(.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ////////////////////////////////////////////////////////////
          /// TOP ROW
          ////////////////////////////////////////////////////////////
          Row(
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.autorenew,
                color: isCompleted ? Colors.green : Colors.blue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isCompleted
                      ? "Resume processing completed"
                      : "Processing resumes...",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JobStatusScreen()),
                  );
                },
                child: const Text("View"),
              ),
            ],
          ),

          ////////////////////////////////////////////////////////////
          /// PROGRESS
          ////////////////////////////////////////////////////////////
          if (!isCompleted) ...[
            const SizedBox(height: 12),

            LinearProgressIndicator(value: percentage / 100, minHeight: 6),

            const SizedBox(height: 6),

            Text(
              "$percentage% • $processed / $total processed",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
