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
    return Row(
      children: [
        _cardFlexible(
          context,
          "Applications",
          summary.totalApplications,
          summaryChange.totalApplications,
          Icons.description_outlined,
        ),
        _gap(),

        _cardFlexible(
          context,
          "Hires",
          summary.hired,
          summaryChange.hired,
          Icons.person_add_alt_outlined,
        ),
        _gap(),

        _cardFlexible(
          context,
          "Jobs",
          summary.totalJobs,
          summaryChange.totalJobs,
          Icons.work_outline,
        ),
        _gap(),

        _cardFlexible(
          context,
          "Partners",
          summary.totalPartners,
          summaryChange.totalPartners,
          Icons.handshake_outlined,
        ),
        _gap(),

        _cardFlexible(
          context,
          "Recruiters",
          summary.totalRecruiters,
          summaryChange.totalRecruiters,
          Icons.groups_outlined,
        ),
        _gap(),

        _cardFlexible(
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
  /// GAP
  ////////////////////////////////////////////////////////////
  Widget _gap() => const SizedBox(width: 8);

  ////////////////////////////////////////////////////////////
  /// FLEXIBLE CARD WRAPPER
  ////////////////////////////////////////////////////////////
  Widget _cardFlexible(
    BuildContext context,
    String title,
    int value,
    double change,
    IconData icon, {
    bool hideChange = false,
  }) {
    return Expanded(
      child: _card(context, title, value, change, icon, hideChange: hideChange),
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
      constraints: const BoxConstraints(
        minWidth: 90, // 👈 prevents breaking too small
      ),
      padding: const EdgeInsets.all(12),

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
          /// TOP ROW
          ////////////////////////////////////////////////////////////
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: theme.colorScheme.primary),
              ),

              const Spacer(),

              if (!hideChange)
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 10,
                      color: changeColor,
                    ),
                    const Gap(2),
                    Text(
                      "${change.toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const Gap(8),

          ////////////////////////////////////////////////////////////
          /// VALUE
          ////////////////////////////////////////////////////////////
          Text(
            value.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const Gap(2),

          ////////////////////////////////////////////////////////////
          /// LABEL
          ////////////////////////////////////////////////////////////
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: .2);
  }
}
