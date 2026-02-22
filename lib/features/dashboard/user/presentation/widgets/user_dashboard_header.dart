import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserDashboardHeader extends StatelessWidget {
  final String name;
  final String range;

  const UserDashboardHeader({
    super.key,
    required this.name,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [scheme.primary, scheme.primary.withOpacity(.85)],
    );

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: gradient,
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
              _Avatar(name),

              const Gap(12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dashboard",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      "Track your job applications",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(.85),
                      ),
                    ),
                  ],
                ),
              ),

              _RangeChip(range),
            ],
          ),

          const Gap(18),

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

class _Avatar extends StatelessWidget {
  final String name;

  const _Avatar(this.name);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white.withOpacity(.18),

      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : "U",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String range;

  const _RangeChip(this.range);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.18),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        range.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
