import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import 'package:gap/gap.dart';

class DashboardPipelineWidget extends StatelessWidget {
  final DashboardPipeline pipeline;

  const DashboardPipelineWidget({super.key, required this.pipeline});

  static const List<_PipelineStageMeta> _stages = [
    _PipelineStageMeta("APPLIED", "Applied", Icons.inbox_outlined),
    _PipelineStageMeta("SCREENING", "Screening", Icons.search_outlined),
    _PipelineStageMeta(
      "INTERVIEW_SCHEDULED",
      "Interview",
      Icons.event_outlined,
    ),
    _PipelineStageMeta("OFFER_SENT", "Offer", Icons.description_outlined),
    _PipelineStageMeta("HIRED", "Hired", Icons.verified_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ////////////////////////////////////////////////////////////
        /// Title
        ////////////////////////////////////////////////////////////
        Text(
          "Hiring Pipeline",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const Gap(12),

        ////////////////////////////////////////////////////////////
        /// Pipeline Container
        ////////////////////////////////////////////////////////////
        Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],

            border: Border.all(color: Colors.grey.withOpacity(.08)),
          ),

          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Row(
              children: List.generate(_stages.length, (index) {
                final stage = _stages[index];

                final count = pipeline.stages[stage.key] ?? 0;

                final isLast = index == _stages.length - 1;

                return Row(
                  children: [
                    _StageItem(
                      icon: stage.icon,
                      label: stage.label,
                      count: count,
                      isHighlight: stage.key == "HIRED",
                    ),

                    if (!isLast)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// Individual Stage Item
////////////////////////////////////////////////////////////

class _StageItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final bool isHighlight;

  const _StageItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.isHighlight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = isHighlight ? Colors.green : theme.colorScheme.primary;

    return Container(
      width: 90,

      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),

      child: Column(
        children: [
          ////////////////////////////////////////////////////////
          /// Icon container
          ////////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: color, size: 20),
          ),

          const Gap(8),

          ////////////////////////////////////////////////////////
          /// Count
          ////////////////////////////////////////////////////////
          Text(
            count.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const Gap(2),

          ////////////////////////////////////////////////////////
          /// Label
          ////////////////////////////////////////////////////////
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// Stage Metadata
////////////////////////////////////////////////////////////

class _PipelineStageMeta {
  final String key;
  final String label;
  final IconData icon;

  const _PipelineStageMeta(this.key, this.label, this.icon);
}
