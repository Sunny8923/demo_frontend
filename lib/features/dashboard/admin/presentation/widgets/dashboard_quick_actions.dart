import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../jobs/presentation/screens/create_single_job_screen.dart';
import '../../../../jobs/presentation/screens/upload_csv_screen.dart';
import '../../../../jobs/presentation/screens/admin_jobs_screen.dart';
import '../../../../partners/presentation/screens/pending_partner_screen.dart';
import '../../../../application/presentation/screens/admin_application_screeen.dart';
import '../../../../application/presentation/screens/ats_pipeline_screen.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

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
          "Quick Actions",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const Gap(12),

        ////////////////////////////////////////////////////////////
        /// Actions Grid (mobile optimized)
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
              icon: Icons.add_box_outlined,
              label: "Create Job",
              color: const Color(0xFF4F46E5),
              onTap: () => _showCreateJobSheet(context),
            ),

            _ActionCard(
              icon: Icons.verified_user_outlined,
              label: "Approve Partners",
              color: const Color(0xFF059669),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PendingPartnerScreen(),
                  ),
                );
              },
            ),

            _ActionCard(
              icon: Icons.work_outline,
              label: "View Jobs",
              color: const Color(0xFFEA580C),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminJobsScreen()),
                );
              },
            ),

            _ActionCard(
              icon: Icons.assignment_outlined,
              label: "Applications",
              color: const Color(0xFF0891B2),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminApplicationsScreen(),
                  ),
                );
              },
            ),

            _ActionCard(
              icon: Icons.account_tree_outlined,
              label: "ATS Pipeline",
              color: const Color(0xFF7C3AED),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AtsPipelineScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////
  /// Create Job Bottom Sheet
  //////////////////////////////////////////////////////////////

  void _showCreateJobSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Create Job",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),

              const Gap(20),

              ListTile(
                leading: const Icon(Icons.add_box_outlined),
                title: const Text("Create Single Job"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateSingleJobScreen(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.upload_file_outlined),
                title: const Text("Upload CSV"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UploadCsvScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// Individual Action Card
////////////////////////////////////////////////////////////

class _ActionCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Ink(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: Colors.grey.withOpacity(.08)),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //////////////////////////////////////////////////////
            /// Icon Container
            //////////////////////////////////////////////////////
            Container(
              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: color.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, color: color, size: 24),
            ),

            const Gap(10),

            //////////////////////////////////////////////////////
            /// Label
            //////////////////////////////////////////////////////
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
