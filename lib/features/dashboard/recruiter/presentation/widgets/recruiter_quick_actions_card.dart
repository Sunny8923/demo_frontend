import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RecruiterDashboardQuickActions extends StatelessWidget {
  const RecruiterDashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: scheme.outlineVariant.withOpacity(.35)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Quick Actions", style: Theme.of(context).textTheme.titleMedium),

          const Gap(16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            children: [
              _action(Icons.person_add, "Add Candidate", Colors.blue),
              _action(Icons.assignment, "Applications", Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String label, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        const Gap(8),
        Text(label),
      ],
    );
  }
}
