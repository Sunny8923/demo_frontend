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
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.1,
      ),

      children: [
        _card(
          context,
          "Applications",
          summary.totalApplications.toString(),
          summaryChange.totalApplications,
          Icons.description_outlined,
          ChartColors.primary,
        ),

        _card(
          context,
          "Hires",
          summary.hired.toString(),
          summaryChange.hired,
          Icons.person_add_alt_outlined,
          ChartColors.success,
        ),

        _card(
          context,
          "Jobs",
          summary.totalJobs.toString(),
          summaryChange.totalJobs,
          Icons.work_outline,
          ChartColors.warning,
        ),

        _card(
          context,
          "Partners",
          summary.totalPartners.toString(),
          summaryChange.totalPartners,
          Icons.handshake_outlined,
          ChartColors.violet,
        ),

        _card(
          context,
          "Recruiters",
          summary.totalRecruiters.toString(),
          summaryChange.totalRecruiters,
          Icons.groups_outlined,
          ChartColors.cyan,
        ),

        _card(
          context,
          "Active Applications",
          summary.activeApplications.toString(),
          0,
          Icons.local_fire_department_outlined,
          ChartColors.error,
          hideChange: true,
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// PREMIUM COLORED CARD
  ////////////////////////////////////////////////////////////

  Widget _card(
    BuildContext context,
    String title,
    String value,
    double change,
    IconData icon,
    Color color, {
    bool hideChange = false,
  }) {
    final theme = Theme.of(context);
    final isPositive = change >= 0;

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        ////////////////////////////////////////////////////////////
        /// SUBTLE PREMIUM GRADIENT
        ////////////////////////////////////////////////////////////
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(.18), color.withOpacity(.05)],
        ),

        border: Border.all(color: color.withOpacity(.28)),

        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(.22),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),

              if (!hideChange) _changeBadge(context, change, isPositive),
            ],
          ),

          const Spacer(),

          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),

          const Gap(4),

          Text(title, style: theme.textTheme.bodyMedium),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(.96, .96));
  }

  ////////////////////////////////////////////////////////////
  /// CHANGE BADGE
  ////////////////////////////////////////////////////////////

  Widget _changeBadge(BuildContext context, double change, bool isPositive) {
    final color = isPositive ? ChartColors.success : ChartColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      decoration: BoxDecoration(
        color: color.withOpacity(.18),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            size: 14,
            color: color,
          ),
          const Gap(4),
          Text(
            "${change.toStringAsFixed(1)}%",
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
