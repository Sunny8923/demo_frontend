import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashboardHeader extends StatelessWidget {
  final String adminName;
  final String range;

  const DashboardHeader({
    super.key,
    required this.adminName,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(.75),
          ],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ////////////////////////////////////////////////////////////
          /// Top row
          ////////////////////////////////////////////////////////////
          Row(
            children: [
              Expanded(
                child: Text(
                  "Admin Dashboard",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              _RangeChip(range: range),
            ],
          ),

          const Gap(12),

          ////////////////////////////////////////////////////////////
          /// Welcome text
          ////////////////////////////////////////////////////////////
          Text(
            "Welcome back,",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(.85),
            ),
          ),

          const Gap(4),

          Text(
            adminName,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),

          const Gap(6),

          ////////////////////////////////////////////////////////////
          /// Subtitle
          ////////////////////////////////////////////////////////////
          Text(
            "Here’s what's happening today",
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(.8),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// Range Chip
////////////////////////////////////////////////////////////

class _RangeChip extends StatelessWidget {
  final String range;

  const _RangeChip({required this.range});

  String get label {
    switch (range) {
      case "7d":
        return "Last 7 days";
      case "30d":
        return "Last 30 days";
      case "90d":
        return "Last 90 days";
      default:
        return range;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 14,
            color: Colors.white,
          ),

          const Gap(6),

          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
