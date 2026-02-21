import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        childAspectRatio: 1.2,
      ),
      children: [
        _card(
          title: "Applications",
          value: summary.totalApplications.toString(),
          change: summaryChange.totalApplications,
          icon: Icons.description_rounded,
          colors: const [Color(0xff6366F1), Color(0xff8B5CF6)],
        ),

        _card(
          title: "Hires",
          value: summary.hired.toString(),
          change: summaryChange.hired,
          icon: Icons.person_add_alt_1_rounded,
          colors: const [Color(0xff10B981), Color(0xff059669)],
        ),

        _card(
          title: "Jobs",
          value: summary.totalJobs.toString(),
          change: summaryChange.totalJobs,
          icon: Icons.work_outline_rounded,
          colors: const [Color(0xffF59E0B), Color(0xffD97706)],
        ),

        _card(
          title: "Partners",
          value: summary.totalPartners.toString(),
          change: summaryChange.totalPartners,
          icon: Icons.handshake_outlined,
          colors: const [Color(0xff3B82F6), Color(0xff2563EB)],
        ),

        _card(
          title: "Recruiters",
          value: summary.totalRecruiters.toString(),
          change: summaryChange.totalRecruiters,
          icon: Icons.groups_rounded,
          colors: const [Color(0xffEC4899), Color(0xffBE185D)],
        ),

        _card(
          title: "Active Applications",
          value: summary.activeApplications.toString(),
          change: 0,
          icon: Icons.local_fire_department_outlined,
          colors: const [Color(0xffEF4444), Color(0xffB91C1C)],
          hideChange: true,
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// Individual Card
  ////////////////////////////////////////////////////////////

  Widget _card({
    required String title,
    required String value,
    required double change,
    required IconData icon,
    required List<Color> colors,
    bool hideChange = false,
  }) {
    final isPositive = change >= 0;

    return Container(
      padding: const EdgeInsets.all(8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ////////////////////////////////////////////////////////////
          /// Top Row
          ////////////////////////////////////////////////////////////
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 26),

              if (!hideChange) _changeBadge(change, isPositive),
            ],
          ),

          const Spacer(),

          ////////////////////////////////////////////////////////////
          /// Value
          ////////////////////////////////////////////////////////////
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const Gap(4),

          ////////////////////////////////////////////////////////////
          /// Title
          ////////////////////////////////////////////////////////////
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(.9)),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(.95, .95));
  }

  ////////////////////////////////////////////////////////////
  /// Change Badge
  ////////////////////////////////////////////////////////////

  Widget _changeBadge(double change, bool isPositive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.2),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            size: 14,
            color: Colors.white,
          ),

          const Gap(2),

          Text(
            "${change.toStringAsFixed(1)}%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
