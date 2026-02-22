import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../application/presentation/screens/my_application_screeen.dart';
import '../../../../jobs/presentation/screens/jobs_list_screen.dart';

class PartnerDashboardQuickActions extends StatelessWidget {
  const PartnerDashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: scheme.outlineVariant.withOpacity(.35)),

        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ////////////////////////////////////////////////////////////
          /// HEADER
          ////////////////////////////////////////////////////////////
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(.12),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Icon(
                  Icons.flash_on_rounded,
                  size: 20,
                  color: scheme.primary,
                ),
              ),

              const Gap(10),

              Text(
                "Quick Actions",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const Gap(16),

          ////////////////////////////////////////////////////////////
          /// GRID
          ////////////////////////////////////////////////////////////
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,

            children: [
              _ActionCard(
                icon: Icons.work_outline,
                label: "Browse Jobs",
                color: const Color(0xFF2563EB),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JobsListScreen()),
                  );
                },
              ),

              _ActionCard(
                icon: Icons.assignment_outlined,
                label: "My Submissions",
                color: const Color(0xFF7C3AED),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyApplicationsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// ACTION CARD
////////////////////////////////////////////////////////////

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),

      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: hovered ? 1.03 : 1,

        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onTap,

          child: Ink(
            decoration: BoxDecoration(
              color: theme.cardColor,

              borderRadius: BorderRadius.circular(16),

              border: Border.all(
                color: hovered
                    ? widget.color.withOpacity(.35)
                    : Colors.grey.withOpacity(.08),
              ),

              boxShadow: [
                BoxShadow(
                  color: hovered
                      ? widget.color.withOpacity(.15)
                      : Colors.black.withOpacity(.04),

                  blurRadius: hovered ? 16 : 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(.12),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(widget.icon, color: widget.color, size: 24),
                ),

                const Gap(10),

                Text(
                  widget.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
