import 'package:flutter/material.dart';
import 'package:frontend/features/application/presentation/screens/my_application_screeen.dart';
import 'package:frontend/features/jobs/presentation/screens/jobs_list_screen.dart';
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
              _action(
                context,
                "Browse Jobs",
                Icons.work_outline,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JobsListScreen()),
                ),
              ),
              _action(
                context,
                "My Applications",
                Icons.assignment_outlined,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyApplicationsScreen(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const Gap(8),
          Text(label),
        ],
      ),
    );
  }
}
