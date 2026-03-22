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
      spacing: 16, // tighter
      runSpacing: 16,
      children: [
        _card(
          context,
          "Applications",
          summary.totalApplications,
          summaryChange.totalApplications,
          Icons.description_outlined,
        ),

        _card(
          context,
          "Hires",
          summary.hired,
          summaryChange.hired,
          Icons.person_add_alt_outlined,
        ),

        _card(
          context,
          "Jobs",
          summary.totalJobs,
          summaryChange.totalJobs,
          Icons.work_outline,
        ),

        _card(
          context,
          "Partners",
          summary.totalPartners,
          summaryChange.totalPartners,
          Icons.handshake_outlined,
        ),

        _card(
          context,
          "Recruiters",
          summary.totalRecruiters,
          summaryChange.totalRecruiters,
          Icons.groups_outlined,
        ),

        _card(
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
  /// CARD UI
  ////////////////////////////////////////////////////////////

  Widget _card(
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

    return Container(
      width: 180, // 🔥 fixed card width (important)
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(.3),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 10),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ////////////////////////////////////////////////////////////
          /// TOP ROW (ICON + LABEL)
          ////////////////////////////////////////////////////////////
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: theme.colorScheme.primary),
              ),

              const Spacer(),

              if (!hideChange)
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
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const Gap(12),

          ////////////////////////////////////////////////////////////
          /// VALUE
          ////////////////////////////////////////////////////////////
          Text(
            value.toString(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const Gap(4),

          ////////////////////////////////////////////////////////////
          /// LABEL
          ////////////////////////////////////////////////////////////
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: .2);
  }
}
