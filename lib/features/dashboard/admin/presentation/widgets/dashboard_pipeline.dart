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
          ////////////////////////////////////////////////////////////
          /// TITLE
          ////////////////////////////////////////////////////////////
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
          /// HORIZONTAL PIPELINE (FIXED)
          ////////////////////////////////////////////////////////////
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: stages.map((stage) {
                final count = pipeline.stages[stage.key] ?? 0;

                return Container(
                  width: 160, // ✅ fixed width
                  margin: const EdgeInsets.only(right: 12),

                  child: _StageTile(
                    label: stage.label,
                    count: count,
                    icon: stage.icon,
                    color: stage.color,
                  ),
                );
              }).toList(),
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),

          const Gap(10),

          ////////////////////////////////////////////////////////////
          /// LABEL
          ////////////////////////////////////////////////////////////
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const Gap(6),

          ////////////////////////////////////////////////////////////
          /// COUNT
          ////////////////////////////////////////////////////////////
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 16,
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
