import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/application/data/models/application_model.dart';
import 'package:frontend/features/application/presentation/providers/admin_application_provider.dart';
import 'package:frontend/features/application/presentation/providers/update_application_stage_provider.dart';

class ApplicationListCard extends ConsumerWidget {
  final ApplicationModel app;

  const ApplicationListCard({super.key, required this.app});

  static const stages = [
    "APPLIED",
    "SCREENING",
    "CONTACTED",
    "DOCUMENT_REQUESTED",
    "DOCUMENT_RECEIVED",
    "SUBMITTED_TO_CLIENT",
    "INTERVIEW_SCHEDULED",
    "INTERVIEW_COMPLETED",
    "SHORTLISTED",
    "OFFER_SENT",
    "OFFER_ACCEPTED",
    "OFFER_REJECTED",
    "HIRED",
    "REJECTED",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final candidate = app.candidate;

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.grey.withOpacity(.08)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ////////////////////////////////////////////////////////////
          /// JOB HEADER
          ////////////////////////////////////////////////////////////
          Row(
            children: [
              /// JOB INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.jobTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    if (app.jobCompanyName != null)
                      Text(
                        app.jobCompanyName!,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    if (app.jobLocation != null)
                      Text(
                        app.jobLocation!,
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              _StageMenu(app: app),
            ],
          ),

          const SizedBox(height: 14),

          ////////////////////////////////////////////////////////////
          /// CANDIDATE
          ////////////////////////////////////////////////////////////
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withOpacity(.1),

                child: Text(
                  candidate.name[0].toUpperCase(),

                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    Text(
                      candidate.email,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              _SourceBadge(source: app.source),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _Chip(icon: Icons.phone, text: candidate.phone),

              if (candidate.totalExperience != null)
                _Chip(
                  icon: Icons.work_outline,
                  text: "${candidate.totalExperience} yrs",
                ),

              if (candidate.expectedSalary != null)
                _Chip(
                  icon: Icons.currency_rupee,
                  text: "₹${candidate.expectedSalary}",
                ),
            ],
          ),

          const SizedBox(height: 12),

          ////////////////////////////////////////////////////////////
          /// FOOTER
          ////////////////////////////////////////////////////////////
          Row(
            children: [
              Text(
                _formatDate(app.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),

              const Spacer(),

              if (app.finalStatus != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: _statusColor(app.finalStatus!).withOpacity(.1),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    app.finalStatus!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _statusColor(app.finalStatus!),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////

  String _formatDate(DateTime date) {
    final d = date.toLocal();
    return "${d.day}/${d.month}/${d.year}";
  }

  Color _statusColor(String status) {
    switch (status) {
      case "HIRED":
        return Colors.green;

      case "REJECTED":
        return Colors.red;

      default:
        return Colors.blue;
    }
  }
}

////////////////////////////////////////////////////////////
/// STAGE MENU
////////////////////////////////////////////////////////////

class _StageMenu extends ConsumerWidget {
  final ApplicationModel app;

  const _StageMenu({required this.app});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),

      onSelected: (stage) async {
        await ref
            .read(updateApplicationStageProvider.notifier)
            .updateStage(applicationId: app.id, pipelineStage: stage);

        ref.read(adminApplicationProvider.notifier).refresh();
      },

      itemBuilder: (_) => ApplicationListCard.stages
          .map((stage) => PopupMenuItem(value: stage, child: Text(stage)))
          .toList(),
    );
  }
}

////////////////////////////////////////////////////////////
/// CHIP
////////////////////////////////////////////////////////////

class _Chip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Chip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.08),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 14), const SizedBox(width: 4), Text(text)],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// SOURCE BADGE
////////////////////////////////////////////////////////////

class _SourceBadge extends StatelessWidget {
  final String? source;

  const _SourceBadge({this.source});

  @override
  Widget build(BuildContext context) {
    if (source == null) return const SizedBox();

    final color = source == "PARTNER" ? Colors.deepPurple : Colors.teal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        source!,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
