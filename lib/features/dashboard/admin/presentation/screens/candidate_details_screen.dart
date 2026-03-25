import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/presentation/providers/candidate_details_provider.dart';
import 'dart:html' as html;

class CandidateDetailScreen extends ConsumerWidget {
  final String candidateId;

  const CandidateDetailScreen({super.key, required this.candidateId});

  ////////////////////////////////////////////////////////////
  /// HELPERS
  ////////////////////////////////////////////////////////////

  String? _clean(String? val) {
    if (val == null || val.trim().isEmpty || val == "NA") return null;
    return val;
  }

  String? _exp(double? val) =>
      val != null ? "${val.toStringAsFixed(1)} yrs" : null;

  String? _salary(double? val) =>
      val != null ? "₹${val.toStringAsFixed(1)} LPA" : null;

  String? _notice(int? val) => val != null ? "$val days" : null;

  Widget _maybeRow(String label, String? value) {
    if (value == null) return const SizedBox();
    return _InfoRow(label, value);
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(candidateDetailProvider(candidateId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Candidate Details")),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),

          data: (c) {
            return ListView(
              children: [
                ////////////////////////////////////////////////////////////
                /// HEADER (ONLY place for company + designation)
                ////////////////////////////////////////////////////////////
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.colorScheme.surfaceVariant.withOpacity(.3),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Text(c.name.isNotEmpty ? c.name[0] : "?"),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.name, style: theme.textTheme.titleLarge),

                            if (_clean(c.designation) != null)
                              Text(_clean(c.designation)!),

                            if (_clean(c.company) != null)
                              Text(_clean(c.company)!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                ////////////////////////////////////////////////////////////
                /// PROFESSIONAL
                ////////////////////////////////////////////////////////////
                _SectionCard(
                  title: "Professional Information",
                  children: [
                    _maybeRow("Experience", _exp(c.experience)),
                    _maybeRow("Department", _clean(c.department)),
                    _maybeRow("Industry", _clean(c.industry)),
                    _maybeRow("Qualification", _clean(c.qualification)),
                  ],
                ),

                const SizedBox(height: 20),

                ////////////////////////////////////////////////////////////
                /// CONTACT
                ////////////////////////////////////////////////////////////
                _SectionCard(
                  title: "Contact Information",
                  children: [
                    _maybeRow("Email", _clean(c.email)),
                    _maybeRow("Phone", _clean(c.phone)),
                    _maybeRow("Location", _clean(c.location)),
                    _maybeRow(
                      "Preferred Locations",
                      _clean(c.preferredLocations),
                    ),
                    _maybeRow("Hometown", _clean(c.hometown)),
                    _maybeRow("Pincode", _clean(c.pincode)),
                  ],
                ),

                const SizedBox(height: 20),

                ////////////////////////////////////////////////////////////
                /// COMPENSATION
                ////////////////////////////////////////////////////////////
                _SectionCard(
                  title: "Compensation",
                  children: [
                    _maybeRow("Current Salary", _salary(c.currentSalary)),
                    _maybeRow("Expected Salary", _salary(c.expectedSalary)),
                    _maybeRow("Notice Period", _notice(c.noticePeriodDays)),
                  ],
                ),

                const SizedBox(height: 20),

                ////////////////////////////////////////////////////////////
                /// SKILLS
                ////////////////////////////////////////////////////////////
                if (c.skills.isNotEmpty)
                  _SectionCard(
                    title: "Skills",
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: c.skills
                            .map(
                              (s) => Chip(
                                label: Text(s),
                                backgroundColor: Colors.blue.withOpacity(.08),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                ////////////////////////////////////////////////////////////
                /// ACTIONS
                ////////////////////////////////////////////////////////////
                _SectionCard(
                  title: "Actions",
                  children: [
                    Row(
                      children: [
                        if (_clean(c.resume) != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              html.window.open(c.resume!, "_blank");
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text("View Resume"),
                          ),

                        if (_clean(c.resume) != null) const SizedBox(width: 12),

                        OutlinedButton(
                          onPressed: () {},
                          child: const Text("Shortlist"),
                        ),

                        const SizedBox(width: 12),

                        OutlinedButton(
                          onPressed: () {},
                          child: const Text("Reject"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// SECTION CARD
////////////////////////////////////////////////////////////

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// INFO ROW
////////////////////////////////////////////////////////////

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
