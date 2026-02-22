import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PartnerDashboardHeader extends StatelessWidget {
  final String partnerName;
  final String range;

  const PartnerDashboardHeader({
    super.key,
    required this.partnerName,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    ////////////////////////////////////////////////////////////
    /// SAME PREMIUM GRADIENT AS ADMIN
    ////////////////////////////////////////////////////////////

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
          ////////////////////////////////////////////////////////////
          /// TOP ROW
          ////////////////////////////////////////////////////////////
          Row(
            children: [
              _Avatar(partnerName),

              const Gap(12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Partner Dashboard",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      "Track your candidates & applications",
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

          ////////////////////////////////////////////////////////////
          /// WELCOME TEXT
          ////////////////////////////////////////////////////////////
          Text(
            "Welcome back",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(.9),
            ),
          ),

          const Gap(4),

          Text(
            partnerName,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),

          const Gap(12),

          ////////////////////////////////////////////////////////////
          /// STATUS TEXT
          ////////////////////////////////////////////////////////////
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),

              const Gap(8),

              Text(
                "Partner account active",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// Avatar
////////////////////////////////////////////////////////////

class _Avatar extends StatelessWidget {
  final String name;

  const _Avatar(this.name);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white.withOpacity(.18),

      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : "P",

        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// Range chip (UI only, no change logic needed)
////////////////////////////////////////////////////////////

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
