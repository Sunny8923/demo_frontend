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

    final stageColor = _statusColor(app.finalStatus ?? "APPLIED");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        gradient: LinearGradient(
          colors: [theme.colorScheme.surface, stageColor.withOpacity(.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        border: Border.all(color: stageColor.withOpacity(.18)),

        boxShadow: [
          BoxShadow(
            color: stageColor.withOpacity(.08),
            blurRadius: 18,
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
                  colors: [stageColor, stageColor.withOpacity(.6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            ////////////////////////////////////////////////////////////
            /// MAIN CONTENT
            ////////////////////////////////////////////////////////////
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    ////////////////////////////////////////////////////////////
                    /// JOB HEADER
                    ////////////////////////////////////////////////////////////
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                app.jobTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                              ),

                              const SizedBox(height: 6),

                              if (app.jobCompanyName != null)
                                Text(
                                  app.jobCompanyName!,
                                  style: TextStyle(
                                    color: stageColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),

                              if (app.jobLocation != null)
                                Text(
                                  app.jobLocation!,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        _StageMenu(app: app),
                      ],
                    ),

                    const SizedBox(height: 16),

                    ////////////////////////////////////////////////////////////
                    /// CANDIDATE SECTION
                    ////////////////////////////////////////////////////////////
                    Container(
                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: stageColor.withOpacity(.06),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: stageColor.withOpacity(.15),

                            child: Text(
                              candidate.name[0].toUpperCase(),
                              style: TextStyle(
                                color: stageColor,
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                Text(
                                  candidate.email,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _SourceBadge(source: app.source),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    ////////////////////////////////////////////////////////////
                    /// INFO CHIPS
                    ////////////////////////////////////////////////////////////
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,

                      children: [
                        _PremiumChip(
                          icon: Icons.phone,
                          text: candidate.phone,
                          color: Colors.blue,
                        ),

                        if (candidate.totalExperience != null)
                          _PremiumChip(
                            icon: Icons.work_outline,
                            text: "${candidate.totalExperience} yrs",
                            color: Colors.orange,
                          ),

                        if (candidate.expectedSalary != null)
                          _PremiumChip(
                            icon: Icons.currency_rupee,
                            text: "₹${candidate.expectedSalary}",
                            color: Colors.green,
                          ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    ////////////////////////////////////////////////////////////
                    /// FOOTER
                    ////////////////////////////////////////////////////////////
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 14, color: Colors.grey[500]),

                        const SizedBox(width: 4),

                        Text(
                          _formatDate(app.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),

                        const Spacer(),

                        if (app.finalStatus != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),

                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  stageColor.withOpacity(.15),
                                  stageColor.withOpacity(.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Text(
                              app.finalStatus!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: stageColor,
                              ),
                            ),
                          ),
                      ],
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

      case "OFFER_SENT":
        return Colors.deepPurple;

      case "INTERVIEW_SCHEDULED":
        return Colors.orange;

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
/// PREMIUM CHIP
////////////////////////////////////////////////////////////

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

        border: Border.all(color: color.withOpacity(.25)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),

          const SizedBox(width: 4),

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

      decoration: BoxDecoration(
        color: color.withOpacity(.12),
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
