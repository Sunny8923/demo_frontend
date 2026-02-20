import 'package:flutter/material.dart';

import '../../data/models/application_model.dart';
import '../../../../core/ui/app_scaffold.dart';

class CandidateDetailScreen extends StatelessWidget {
  final ApplicationModel application;

  const CandidateDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final candidate = application.candidate;
    final theme = Theme.of(context);

    return AppScaffold(
      title: "Candidate Profile",

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ////////////////////////////////////////////////////////////
            /// HEADER
            ////////////////////////////////////////////////////////////
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text(
                    candidate.name.isNotEmpty
                        ? candidate.name[0].toUpperCase()
                        : "?",
                    style: const TextStyle(fontSize: 24),
                  ),
                ),

                const SizedBox(width: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      candidate.email,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            ////////////////////////////////////////////////////////////
            /// APPLICATION INFO
            ////////////////////////////////////////////////////////////
            _SectionTitle("Application Info"),

            _InfoTile("Job", application.jobTitle),

            _InfoTile("Stage", application.pipelineStage),

            _InfoTile("Applied On", _formatDate(application.createdAt)),

            if (application.source != null)
              _InfoTile("Source", application.source!),

            const SizedBox(height: 24),

            ////////////////////////////////////////////////////////////
            /// CONTACT
            ////////////////////////////////////////////////////////////
            _SectionTitle("Contact"),

            _InfoTile("Phone", candidate.phone),

            if (candidate.currentLocation != null)
              _InfoTile("Location", candidate.currentLocation!),

            const SizedBox(height: 24),

            ////////////////////////////////////////////////////////////
            /// PROFESSIONAL INFO
            ////////////////////////////////////////////////////////////
            _SectionTitle("Professional"),

            if (candidate.currentCompany != null)
              _InfoTile("Company", candidate.currentCompany!),

            if (candidate.currentDesignation != null)
              _InfoTile("Designation", candidate.currentDesignation!),

            if (candidate.totalExperience != null)
              _InfoTile("Experience", "${candidate.totalExperience} years"),

            if (candidate.expectedSalary != null)
              _InfoTile("Expected Salary", "₹${candidate.expectedSalary}"),

            if (candidate.noticePeriodDays != null)
              _InfoTile("Notice Period", "${candidate.noticePeriodDays} days"),

            const SizedBox(height: 24),

            ////////////////////////////////////////////////////////////
            /// EDUCATION
            ////////////////////////////////////////////////////////////
            _SectionTitle("Education"),

            if (candidate.highestQualification != null)
              _InfoTile("Qualification", candidate.highestQualification!),

            if (candidate.university != null)
              _InfoTile("University", candidate.university!),

            if (candidate.graduationYear != null)
              _InfoTile("Graduation Year", candidate.graduationYear.toString()),

            const SizedBox(height: 24),

            ////////////////////////////////////////////////////////////
            /// SKILLS
            ////////////////////////////////////////////////////////////
            if (candidate.skills != null) ...[
              _SectionTitle("Skills"),

              Wrap(
                spacing: 8,
                children: candidate.skills!
                    .split(",")
                    .map((skill) => Chip(label: Text(skill.trim())))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// Helpers
  ////////////////////////////////////////////////////////////

  static String _formatDate(DateTime date) {
    final d = date.toLocal();

    return "${d.day}/${d.month}/${d.year}";
  }
}

////////////////////////////////////////////////////////////
/// Widgets
////////////////////////////////////////////////////////////

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
