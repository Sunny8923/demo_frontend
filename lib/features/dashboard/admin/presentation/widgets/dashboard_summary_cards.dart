import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/core/ui/chart_colors.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import 'package:gap/gap.dart';

class DashboardSummaryCards extends StatelessWidget {
  final DashboardSummary summary;
  final DashboardSummaryChange summaryChange;

  const DashboardSummaryCards({
    super.key,
    required this.summary,
    required this.summaryChange,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 28,
      runSpacing: 16,
      children: [
        _item(
          context,
          "Applications",
          summary.totalApplications,
          summaryChange.totalApplications,
          Icons.description_outlined,
        ),
        _item(
          context,
          "Hires",
          summary.hired,
          summaryChange.hired,
          Icons.person_add_alt_outlined,
        ),
        _item(
          context,
          "Jobs",
          summary.totalJobs,
          summaryChange.totalJobs,
          Icons.work_outline,
        ),
        _item(
          context,
          "Partners",
          summary.totalPartners,
          summaryChange.totalPartners,
          Icons.handshake_outlined,
        ),
        _item(
          context,
          "Recruiters",
          summary.totalRecruiters,
          summaryChange.totalRecruiters,
          Icons.groups_outlined,
        ),
        _item(
          context,
          "Active",
          summary.activeApplications,
          0,
          Icons.local_fire_department_outlined,
          hideChange: true,
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// COMPACT STAT ITEM
  ////////////////////////////////////////////////////////////

  Widget _item(
    BuildContext context,
    String title,
    int value,
    double change,
    IconData icon, {
    bool hideChange = false,
  }) {
    final theme = Theme.of(context);
    final isPositive = change >= 0;
    final changeColor = isPositive ? ChartColors.success : ChartColors.error;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ////////////////////////////////////////////////////////////
        /// ICON
        ////////////////////////////////////////////////////////////
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18),
        ),

        const Gap(10),

        ////////////////////////////////////////////////////////////
        /// TEXT
        ////////////////////////////////////////////////////////////
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            Row(
              children: [
                Text(
                  value.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                if (!hideChange) ...[
                  const Gap(6),
                  Row(
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: changeColor,
                      ),
                      const Gap(2),
                      Text(
                        "${change.toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontSize: 12,
                          color: changeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 300.ms).slideY(begin: .2);
  }
}
