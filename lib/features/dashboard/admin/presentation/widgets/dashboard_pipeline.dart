import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import 'package:gap/gap.dart';

class DashboardPipelineWidget extends StatelessWidget {
  final DashboardPipeline pipeline;

  const DashboardPipelineWidget({super.key, required this.pipeline});

  ////////////////////////////////////////////////////////////
  /// STAGES CONFIG
  ////////////////////////////////////////////////////////////

  static const stages = [
    _StageMeta("APPLIED", "Applied", Icons.inbox_outlined, Color(0xff3B82F6)),
    _StageMeta("SCREENING", "Screening", Icons.search, Color(0xff8B5CF6)),
    _StageMeta(
      "INTERVIEW_SCHEDULED",
      "Interview",
      Icons.groups,
      Color(0xffF59E0B),
    ),
    _StageMeta(
      "OFFER_SENT",
      "Offer Sent",
      Icons.description,
      Color(0xffEC4899),
    ),
    _StageMeta("HIRED", "Hired", Icons.verified, Color(0xff10B981)),
  ];

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xff111827),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recruitment Pipeline",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const Gap(16),

          ////////////////////////////////////////////////////////////
          /// STAGE TILES
          ////////////////////////////////////////////////////////////
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 700;

              if (!isDesktop) {
                // mobile layout (your current vertical list)
                return Column(
                  children: stages.map((stage) {
                    final count = pipeline.stages[stage.key] ?? 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _StageTile(
                        label: stage.label,
                        count: count,
                        icon: stage.icon,
                        color: stage.color,
                      ),
                    );
                  }).toList(),
                );
              }

              // desktop layout (horizontal pipeline)
              return Row(
                children: stages.map((stage) {
                  final count = pipeline.stages[stage.key] ?? 0;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _StageTile(
                        label: stage.label,
                        count: count,
                        icon: stage.icon,
                        color: stage.color,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// STAGE TILE
////////////////////////////////////////////////////////////

class _StageTile extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const _StageTile({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xff1F2937),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          ////////////////////////////////////////////////////////////
          /// ICON
          ////////////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, color: color),
          ),

          const Gap(16),

          ////////////////////////////////////////////////////////////
          /// LABEL
          ////////////////////////////////////////////////////////////
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          ////////////////////////////////////////////////////////////
          /// COUNT
          ////////////////////////////////////////////////////////////
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// META
////////////////////////////////////////////////////////////

class _StageMeta {
  final String key;
  final String label;
  final IconData icon;
  final Color color;

  const _StageMeta(this.key, this.label, this.icon, this.color);
}
