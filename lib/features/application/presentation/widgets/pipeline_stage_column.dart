import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/application/data/models/application_model.dart';
import 'package:frontend/features/application/presentation/providers/admin_application_provider.dart';
import 'package:frontend/features/application/presentation/providers/update_application_stage_provider.dart';
import 'package:frontend/features/application/presentation/screens/candidate_details_screen.dart';

class PipelineStageColumn extends ConsumerWidget {
  final String stage;
  final List<ApplicationModel> applications;

  const PipelineStageColumn({
    super.key,
    required this.stage,
    required this.applications,
  });

  static const stages = [
    "APPLIED",
    "SCREENING",
    "CONTACTED",
    "INTERVIEW_SCHEDULED",
    "INTERVIEW_COMPLETED",
    "OFFER_SENT",
    "HIRED",
    "REJECTED",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      width: 320,

      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.04),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          ////////////////////////////////////////////////////////////
          /// HEADER (FIXED)
          ////////////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),

            child: Row(
              children: [
                Expanded(
                  child: Text(
                    stage,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),

                CircleAvatar(
                  radius: 12,
                  backgroundColor: theme.colorScheme.primary,

                  child: Text(
                    applications.length.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          ////////////////////////////////////////////////////////////
          /// SCROLLABLE APPLICATION LIST (FIXES OVERFLOW)
          ////////////////////////////////////////////////////////////
          Expanded(
            child: applications.isEmpty
                ? Center(
                    child: Text(
                      "No candidates",
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),

                    itemCount: applications.length,

                    itemBuilder: (context, index) {
                      final app = applications[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),

                        child: _PipelineCard(app: app),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// PIPELINE CARD
////////////////////////////////////////////////////////////

class _PipelineCard extends ConsumerWidget {
  final ApplicationModel app;

  const _PipelineCard({required this.app});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(10),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CandidateDetailScreen(application: app),
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),

          border: Border.all(color: Colors.grey.withOpacity(.08)),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ////////////////////////////////////////////////////////////
            /// Candidate Name
            ////////////////////////////////////////////////////////////
            Text(
              app.candidate.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),

            const SizedBox(height: 4),

            ////////////////////////////////////////////////////////////
            /// Job Title
            ////////////////////////////////////////////////////////////
            Text(
              app.jobTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),

            const SizedBox(height: 6),

            ////////////////////////////////////////////////////////////
            /// Email
            ////////////////////////////////////////////////////////////
            Text(
              app.candidate.email,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),

            const SizedBox(height: 8),

            ////////////////////////////////////////////////////////////
            /// Stage Menu
            ////////////////////////////////////////////////////////////
            Align(
              alignment: Alignment.centerRight,

              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),

                onSelected: (stage) async {
                  await ref
                      .read(updateApplicationStageProvider.notifier)
                      .updateStage(applicationId: app.id, pipelineStage: stage);

                  ref.read(adminApplicationProvider.notifier).refresh();
                },

                itemBuilder: (_) => PipelineStageColumn.stages
                    .map(
                      (stage) =>
                          PopupMenuItem(value: stage, child: Text(stage)),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
