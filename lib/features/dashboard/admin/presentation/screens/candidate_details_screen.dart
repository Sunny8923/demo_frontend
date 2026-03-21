import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/presentation/providers/candidate_details_provider.dart';
import 'dart:html' as html;

class CandidateDetailScreen extends ConsumerWidget {
  final String candidateId;

  const CandidateDetailScreen({super.key, required this.candidateId});

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
                /// HEADER CARD
                ////////////////////////////////////////////////////////////
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant.withOpacity(.3),
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
                            Text(
                              c.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(c.designation ?? "-"),
                            Text(c.company ?? "-"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                ////////////////////////////////////////////////////////////
                /// BASIC INFO
                ////////////////////////////////////////////////////////////
                _SectionCard(
                  title: "Basic Information",
                  children: [
                    _InfoRow("Email", c.email),
                    _InfoRow("Phone", c.phone),
                    _InfoRow("Location", c.location ?? "-"),
                    _InfoRow("Experience", "${c.experience ?? 0} yrs"),
                  ],
                ),

                const SizedBox(height: 20),

                ////////////////////////////////////////////////////////////
                /// SKILLS
                ////////////////////////////////////////////////////////////
                _SectionCard(
                  title: "Skills",
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: c.skills
                          .map((s) => Chip(label: Text(s)))
                          .toList(),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ////////////////////////////////////////////////////////////
                /// ACTIONS
                ////////////////////////////////////////////////////////////
                Row(
                  children: [
                    if (c.resume != null)
                      ElevatedButton.icon(
                        onPressed: () {
                          html.window.open(c.resume!, "_blank");
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("View Resume"),
                      ),

                    const SizedBox(width: 12),

                    OutlinedButton(
                      onPressed: () {
                        // future: shortlist
                      },
                      child: const Text("Shortlist"),
                    ),

                    const SizedBox(width: 12),

                    OutlinedButton(
                      onPressed: () {
                        // future: reject
                      },
                      child: const Text("Reject"),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
