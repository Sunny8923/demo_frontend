import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import 'package:gap/gap.dart';

class DashboardPipelineWidget extends StatelessWidget {
  final DashboardPipeline pipeline;

  const DashboardPipelineWidget({super.key, required this.pipeline});

  ////////////////////////////////////////////////////////////
  /// Premium stage configuration with colors
  ////////////////////////////////////////////////////////////

  static const List<_PipelineStageMeta> _stages = [
    _PipelineStageMeta(
      key: "APPLIED",
      label: "Applied",
      icon: Icons.inbox_outlined,
      color: Color(0xff6366F1),
    ),

    _PipelineStageMeta(
      key: "SCREENING",
      label: "Screening",
      icon: Icons.search_outlined,
      color: Color(0xff8B5CF6),
    ),

    _PipelineStageMeta(
      key: "INTERVIEW_SCHEDULED",
      label: "Interview",
      icon: Icons.event_outlined,
      color: Color(0xffF59E0B),
    ),

    _PipelineStageMeta(
      key: "OFFER_SENT",
      label: "Offer",
      icon: Icons.description_outlined,
      color: Color(0xffEC4899),
    ),

    _PipelineStageMeta(
      key: "HIRED",
      label: "Hired",
      icon: Icons.verified_rounded,
      color: Color(0xff10B981),
    ),
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
            fontWeight: FontWeight.w700,
          ),
        ),

        const Gap(14),

        ////////////////////////////////////////////////////////////
        /// Premium container
        ////////////////////////////////////////////////////////////
        Container(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),

            gradient: LinearGradient(
              colors: [const Color(0xff0F172A), const Color(0xff111827)],
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
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
                    _PremiumStageItem(stage: stage, count: count),

                    if (!isLast)
                      _Connector(
                        fromColor: stage.color,
                        toColor: _stages[index + 1].color,
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
/// Premium Stage Item
////////////////////////////////////////////////////////////

class _PremiumStageItem extends StatelessWidget {
  final _PipelineStageMeta stage;
  final int count;

  const _PremiumStageItem({required this.stage, required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,

      child: Column(
        children: [
          ////////////////////////////////////////////////////////////
          /// Gradient icon circle
          ////////////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient: LinearGradient(
                colors: [stage.color, stage.color.withOpacity(.7)],
              ),

              boxShadow: [
                BoxShadow(
                  color: stage.color.withOpacity(.5),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: Icon(stage.icon, color: Colors.white, size: 20),
          ),

          const Gap(12),

          ////////////////////////////////////////////////////////////
          /// Count
          ////////////////////////////////////////////////////////////
          Text(
            _format(count),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const Gap(4),

          ////////////////////////////////////////////////////////////
          /// Label
          ////////////////////////////////////////////////////////////
          Text(
            stage.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(.7),
            ),
          ),
        ],
      ),
    );
  }

  String _format(int number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    }

    if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }

    return number.toString();
  }
}

////////////////////////////////////////////////////////////
/// Premium connector line
////////////////////////////////////////////////////////////

class _Connector extends StatelessWidget {
  final Color fromColor;
  final Color toColor;

  const _Connector({required this.fromColor, required this.toColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),

      width: 36,
      height: 4,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),

        gradient: LinearGradient(colors: [fromColor, toColor]),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// Stage metadata
////////////////////////////////////////////////////////////

class _PipelineStageMeta {
  final String key;
  final String label;
  final IconData icon;
  final Color color;

  const _PipelineStageMeta({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });
}
