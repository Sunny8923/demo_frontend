import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/features/dashboard/recruiter/data/model/recruiter_dashboard_model.dart';

class RecruiterDashboardSummaryCards extends StatelessWidget {
  final RecruiterDashboardModel dashboard;

  const RecruiterDashboardSummaryCards({super.key, required this.dashboard});

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
          "Candidates",
          dashboard.totalCandidatesAdded,
          Icons.people,
          const Color(0xFF2563EB),
        ),

        _card(
          "Active Jobs",
          dashboard.activeJobsWorkedOn,
          Icons.work_outline,
          const Color(0xFF7C3AED),
        ),

        _card(
          "Applications",
          dashboard.totalApplications,
          Icons.assignment_outlined,
          const Color(0xFFEA580C),
        ),

        _card(
          "Hired",
          dashboard.hired,
          Icons.check_circle_outline,
          const Color(0xFF059669),
        ),

        _card(
          "Rejected",
          dashboard.rejected,
          Icons.cancel_outlined,
          const Color(0xFFDC2626),
        ),
      ],
    );
  }

  Widget _card(String title, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        gradient: LinearGradient(
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
          Icon(icon, color: color),

          const Spacer(),

          Text(
            value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: color,
            ),
          ),

          Text(title),
        ],
      ),
    ).animate().fadeIn().scale();
  }
}
