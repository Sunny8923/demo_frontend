import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import 'package:gap/gap.dart';

class DashboardLeaderboardsWidget extends StatelessWidget {
  final DashboardLeaderboards leaderboards;

  const DashboardLeaderboardsWidget({super.key, required this.leaderboards});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ////////////////////////////////////////////////////////////
        /// Title
        ////////////////////////////////////////////////////////////
        Text(
          "Leaderboards",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const Gap(12),

        ////////////////////////////////////////////////////////////
        /// Top Partners
        ////////////////////////////////////////////////////////////
        _LeaderboardCard(
          title: "Top Partners",
          icon: Icons.emoji_events_outlined,
          children: leaderboards.topPartners
              .map(
                (partner) => _LeaderboardItem(
                  title: partner.partnerName,
                  subtitle: "Partner",
                  value: "${partner.applications} applications",
                ),
              )
              .toList(),
        ),

        const Gap(12),

        ////////////////////////////////////////////////////////////
        /// Top Jobs
        ////////////////////////////////////////////////////////////
        _LeaderboardCard(
          title: "Top Jobs",
          icon: Icons.work_outline,
          children: leaderboards.topJobs
              .map(
                (job) => _LeaderboardItem(
                  title: job.jobTitle,
                  subtitle: "Job",
                  value: "${job.applications} applications",
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// Card Container
////////////////////////////////////////////////////////////

class _LeaderboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _LeaderboardCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],

        border: Border.all(color: Colors.grey.withOpacity(.08)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ////////////////////////////////////////////////////////
          /// Header
          ////////////////////////////////////////////////////////
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Icon(icon, size: 18, color: theme.colorScheme.primary),
              ),

              const Gap(10),

              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const Gap(12),

          ////////////////////////////////////////////////////////
          /// List
          ////////////////////////////////////////////////////////
          if (children.isEmpty)
            const Text(
              "No data available",
              style: TextStyle(color: Colors.grey),
            )
          else
            Column(children: children),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// Individual Item
////////////////////////////////////////////////////////////

class _LeaderboardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;

  const _LeaderboardItem({
    required this.title,
    required this.subtitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        children: [
          ////////////////////////////////////////////////////////
          /// Avatar circle
          ////////////////////////////////////////////////////////
          CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.primary.withOpacity(.1),
            child: Text(
              title.isNotEmpty ? title[0].toUpperCase() : "?",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Gap(12),

          ////////////////////////////////////////////////////////
          /// Name + subtitle
          ////////////////////////////////////////////////////////
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          ////////////////////////////////////////////////////////
          /// Value
          ////////////////////////////////////////////////////////
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
