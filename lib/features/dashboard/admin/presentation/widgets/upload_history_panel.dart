import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/shared/job_history_provider.dart';
import 'package:frontend/features/dashboard/admin/presentation/screens/job_status_screen.dart';

class UploadHistoryPanel extends ConsumerWidget {
  const UploadHistoryPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(jobHistoryProvider);

    if (jobs.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Uploads",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          ...jobs
              .take(5)
              .map(
                (job) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Job ${job.jobId.substring(0, 6)}"),
                  subtitle: Text(
                    DateTime.fromMillisecondsSinceEpoch(
                      job.createdAt,
                    ).toString(),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobStatusScreen(jobId: job.jobId),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
