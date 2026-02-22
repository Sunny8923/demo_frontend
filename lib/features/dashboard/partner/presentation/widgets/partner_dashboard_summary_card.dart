import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../../data/models/partner_dashboard_model.dart';

class PartnerDashboardSummaryCards extends StatelessWidget {
  final PartnerDashboardModel dashboard;

  const PartnerDashboardSummaryCards({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.15,
      ),

      children: [
        _card(
          context,
          "Candidates",
          dashboard.totalCandidates.toString(),
          Icons.people_outline,
          const Color(0xFF2563EB),
        ),

        _card(
          context,
          "Applications",
          dashboard.totalApplications.toString(),
          Icons.description_outlined,
          const Color(0xFF7C3AED),
        ),

        _card(
          context,
          "Active",
          dashboard.activeApplications.toString(),
          Icons.timelapse_outlined,
          const Color(0xFFEA580C),
        ),

        _card(
          context,
          "Hired",
          dashboard.hired.toString(),
          Icons.check_circle_outline,
          const Color(0xFF059669),
        ),

        _card(
          context,
          "Rejected",
          dashboard.rejected.toString(),
          Icons.cancel_outlined,
          const Color(0xFFDC2626),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////
  /// PREMIUM CARD (same design as admin)
  ////////////////////////////////////////////////////////////

  Widget _card(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

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
          ////////////////////////////////////////////////////////////
          /// ICON
          ////////////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.all(8),

            decoration: BoxDecoration(
              color: color.withOpacity(.22),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, color: color, size: 20),
          ),

          const Spacer(),

          ////////////////////////////////////////////////////////////
          /// VALUE
          ////////////////////////////////////////////////////////////
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),

          const Gap(4),

          ////////////////////////////////////////////////////////////
          /// TITLE
          ////////////////////////////////////////////////////////////
          Text(title, style: theme.textTheme.bodyMedium),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(.96, .96));
  }
}
