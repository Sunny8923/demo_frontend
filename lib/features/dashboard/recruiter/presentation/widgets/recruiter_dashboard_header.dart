import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RecruiterDashboardHeader extends StatelessWidget {
  final String name;

  const RecruiterDashboardHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.primary.withOpacity(.85)],
        ),

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: scheme.primary.withOpacity(.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withOpacity(.18),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "R",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Gap(12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recruiter Dashboard",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      "Manage candidates & applications",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Gap(16),

          Text(
            "Welcome back",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(.9),
            ),
          ),

          const Gap(4),

          Text(
            name,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
