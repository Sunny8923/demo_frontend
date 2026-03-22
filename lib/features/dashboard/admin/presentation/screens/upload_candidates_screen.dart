import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/admin/presentation/screens/upload_candidate_csv_screen.dart';
import 'package:frontend/features/dashboard/admin/presentation/widgets/upload_history_panel.dart';
import 'package:gap/gap.dart';
import 'upload_resume_screen.dart';

class UploadCandidatesScreen extends StatelessWidget {
  const UploadCandidatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text("Upload Candidates"), elevation: 0),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ////////////////////////////////////////////////////////////
                /// HEADER
                ////////////////////////////////////////////////////////////
                Text(
                  "Choose Upload Type",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Gap(8),

                Text(
                  "Upload candidates using CSV or resumes",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),

                const Gap(24),

                ////////////////////////////////////////////////////////////
                /// OPTIONS
                ////////////////////////////////////////////////////////////
                isWeb
                    ? Row(
                        children: [
                          Expanded(
                            child: _UploadOptionCard(
                              icon: Icons.upload_file_rounded,
                              title: "Upload CSV",
                              description:
                                  "Bulk upload candidates using CSV file",
                              color: const Color(0xFF4F46E5),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const UploadCandidateCsvScreen(),
                                  ),
                                );
                              },
                            ),
                          ),

                          const Gap(20),

                          Expanded(
                            child: _UploadOptionCard(
                              icon: Icons.description_outlined,
                              title: "Upload Resumes",
                              description: "Upload single or multiple resumes",
                              color: const Color(0xFF16A34A),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const UploadResumeScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _UploadOptionCard(
                            icon: Icons.upload_file_rounded,
                            title: "Upload CSV",
                            description:
                                "Bulk upload candidates using CSV file",
                            color: const Color(0xFF4F46E5),
                            onTap: () {},
                          ),

                          const Gap(16),

                          _UploadOptionCard(
                            icon: Icons.description_outlined,
                            title: "Upload Resumes",
                            description: "Upload single or multiple resumes",
                            color: const Color(0xFF16A34A),
                            onTap: () {},
                          ),
                        ],
                      ),

                const Gap(32),

                ////////////////////////////////////////////////////////////
                /// HISTORY SECTION (NEW)
                ////////////////////////////////////////////////////////////
                Text(
                  "Recent Uploads",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Gap(12),

                const UploadHistoryPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// CARD
////////////////////////////////////////////////////////////

class _UploadOptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _UploadOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  State<_UploadOptionCard> createState() => _UploadOptionCardState();
}

class _UploadOptionCardState extends State<_UploadOptionCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),

      child: GestureDetector(
        onTap: widget.onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: hovered
                  ? widget.color.withOpacity(.4)
                  : Colors.grey.withOpacity(.15),
            ),

            boxShadow: [
              BoxShadow(
                color: hovered
                    ? widget.color.withOpacity(.15)
                    : Colors.black.withOpacity(.05),
                blurRadius: hovered ? 18 : 10,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: widget.color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(widget.icon, color: widget.color, size: 26),
              ),

              const Gap(16),

              Text(
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Gap(6),

              Text(
                widget.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
