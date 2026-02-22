import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/user_dashboard_model.dart';

class UserDashboardSummaryCards extends StatelessWidget {
  final UserDashboardModel dashboard;

  const UserDashboardSummaryCards({super.key, required this.dashboard});

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
          "Applications",
          dashboard.totalApplications,
          Icons.assignment_outlined,
          Colors.blue,
        ),

        _card(
          "Active",
          dashboard.activeApplications,
          Icons.pending_actions_outlined,
          Colors.orange,
        ),

        _card(
          "Hired",
          dashboard.hired,
          Icons.check_circle_outline,
          Colors.green,
        ),

        _card(
          "Rejected",
          dashboard.rejected,
          Icons.cancel_outlined,
          Colors.red,
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          Text(title),
        ],
      ),
    ).animate().fadeIn().scale();
  }
}
