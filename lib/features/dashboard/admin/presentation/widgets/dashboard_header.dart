import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/presentation/providers/admin_dashboard_provider.dart';
import 'package:gap/gap.dart';

class DashboardHeader extends ConsumerWidget {
  final String adminName;
  final String range;

  const DashboardHeader({
    super.key,
    required this.adminName,
    required this.range,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    ////////////////////////////////////////////////////////////
    /// PREMIUM GRADIENT (MATCHES KPI CARDS STYLE)
    ////////////////////////////////////////////////////////////

    const gradient = LinearGradient(
      colors: [Color(0xff6366F1), Color(0xff8B5CF6), Color(0xffEC4899)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: gradient,

        ////////////////////////////////////////////////////////////
        /// PREMIUM SOFT SHADOW (NO WHITE EDGE)
        ////////////////////////////////////////////////////////////
        boxShadow: [
          BoxShadow(
            color: const Color(0xff6366F1).withOpacity(.35),
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
              _Avatar(adminName),

              const Gap(12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Admin Dashboard",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      "Analytics overview & insights",
                      style: theme.textTheme.bodySmall?.copyWith(
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
            "Welcome back,",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(.9),
            ),
          ),

          const Gap(2),

          Text(
            adminName,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),

          const Gap(10),

          ////////////////////////////////////////////////////////////
          /// STATUS ROW
          ////////////////////////////////////////////////////////////
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),

              const Gap(8),

              Text(
                "System active • Realtime analytics enabled",
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
/// PREMIUM AVATAR (NO WHITE EDGE)
////////////////////////////////////////////////////////////

class _Avatar extends StatelessWidget {
  final String name;

  const _Avatar(this.name);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white.withOpacity(.15),

      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : "A",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// PREMIUM RANGE CHIP (MATCHES HEADER)
////////////////////////////////////////////////////////////

class _RangeChip extends ConsumerWidget {
  final String range;

  const _RangeChip(this.range);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _option(ref, "7d", range == "7d"),
          _option(ref, "30d", range == "30d"),
        ],
      ),
    );
  }

  Widget _option(WidgetRef ref, String value, bool selected) {
    return GestureDetector(
      onTap: () {
        ref.read(adminDashboardProvider.notifier).changeRange(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          value.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
