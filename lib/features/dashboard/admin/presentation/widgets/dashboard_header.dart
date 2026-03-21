import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/presentation/providers/admin_dashboard_provider.dart';
import 'package:gap/gap.dart';

class DashboardHeader extends ConsumerWidget {
  final String adminName;

  const DashboardHeader({super.key, required this.adminName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final range = ref.watch(
      adminDashboardProvider.notifier.select((n) => n.currentRange),
    );

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
              _Avatar(adminName),
              const Gap(12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Admin Dashboard",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Platform analytics & system overview",
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
            adminName,
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

////////////////////////////////////////////////////////////
/// AVATAR
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
/// RANGE CHIP
////////////////////////////////////////////////////////////

class _RangeChip extends ConsumerWidget {
  final String range;

  const _RangeChip(this.range);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adminDashboardProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button("7D", "7d", range == "7d", notifier),
          _button("30D", "30d", range == "30d", notifier),
        ],
      ),
    );
  }

  Widget _button(
    String text,
    String value,
    bool selected,
    AdminDashboardNotifier notifier,
  ) {
    return Material(
      color: Colors.transparent, // 👈 IMPORTANT
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          notifier.changeRange(value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withOpacity(.28)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
