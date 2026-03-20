import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/admin/presentation/screens/create_recruiter_screen.dart';
import 'package:gap/gap.dart';

import '../../../../jobs/presentation/screens/create_single_job_screen.dart';
import '../../../../jobs/presentation/screens/upload_csv_screen.dart';
import '../../../../jobs/presentation/screens/admin_jobs_screen.dart';
import '../../../../partners/presentation/screens/pending_partner_screen.dart';
import '../../../../application/presentation/screens/admin_application_screeen.dart';
import '../../../../application/presentation/screens/ats_pipeline_screen.dart';
import '../screens/upload_candidates_screen.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      ////////////////////////////////////////////////////////////
      /// PREMIUM OUTER CARD (NEW)
      ////////////////////////////////////////////////////////////
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
                icon: Icons.add_box_outlined,
                label: "Create Job",
                color: const Color(0xFF4F46E5),
                onTap: () => _showCreateJobSheet(context),
              ),

              _ActionCard(
                icon: Icons.person_add_alt_1_outlined,
                label: "Create Recruiter",
                color: const Color(0xFF2563EB),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateRecruiterScreen(),
                    ),
                  );
                },
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
                    MaterialPageRoute(
                      builder: (_) => const AtsPipelineScreen(),
                    ),
                  );
                },
              ),
              _ActionCard(
                icon: Icons.upload_file_rounded,
                label: "Upload Candidates",
                color: const Color(0xFF16A34A),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          UploadCandidatesScreen(), // we will create next
                    ),
                  );
                },
              ),

              _ActionCard(
                icon: Icons.groups_rounded,
                label: "View Candidates",
                color: const Color(0xFF0EA5E9),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ViewCandidatesScreen(), // later
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

  //////////////////////////////////////////////////////////////
  /// Create Job Bottom Sheet (UNCHANGED)
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
/// PREMIUM ACTION CARD (UPGRADED)
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
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),

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
