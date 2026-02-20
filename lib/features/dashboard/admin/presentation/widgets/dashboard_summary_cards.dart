import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import 'package:gap/gap.dart';

class DashboardSummaryCards extends StatelessWidget {
  final DashboardSummary summary;

  const DashboardSummaryCards({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: "Total Jobs",
                value: summary.totalJobs.toString(),
                icon: Icons.work_outline,
                color: const Color(0xFF4F46E5),
              ),
            ),
            const Gap(12),
            Expanded(
              child: _SummaryCard(
                title: "Applications",
                value: summary.totalApplications.toString(),
                icon: Icons.assignment_outlined,
                color: const Color(0xFF059669),
              ),
            ),
          ],
        ),

        const Gap(12),

        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: "Partners",
                value: summary.totalPartners.toString(),
                icon: Icons.groups_outlined,
                color: const Color(0xFFEA580C),
              ),
            ),
            const Gap(12),
            Expanded(
              child: _SummaryCard(
                title: "Hired",
                value: summary.hired.toString(),
                icon: Icons.verified_outlined,
                color: const Color(0xFFDC2626),
              ),
            ),
          ],
        ),

        const Gap(12),

        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: "Open Jobs",
                value: summary.openJobs.toString(),
                icon: Icons.folder_open_outlined,
                color: const Color(0xFF0891B2),
              ),
            ),
            const Gap(12),
            Expanded(
              child: _SummaryCard(
                title: "Pending Partners",
                value: summary.pendingPartners.toString(),
                icon: Icons.pending_actions_outlined,
                color: const Color(0xFF7C3AED),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// Individual Summary Card
////////////////////////////////////////////////////////////

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //////////////////////////////////////////////////////
          /// Top Row (Icon)
          //////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, size: 20, color: color),
          ),

          const Gap(14),

          //////////////////////////////////////////////////////
          /// Value
          //////////////////////////////////////////////////////
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const Gap(4),

          //////////////////////////////////////////////////////
          /// Title
          //////////////////////////////////////////////////////
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
