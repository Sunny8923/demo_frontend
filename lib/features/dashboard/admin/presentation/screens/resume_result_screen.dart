import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/admin/presentation/screens/candidate_details_screen.dart';

class ResumeResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResumeResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ////////////////////////////////////////////////////////////
    /// SAFE PARSING
    ////////////////////////////////////////////////////////////
    final results = (result["results"] as List?) ?? [];

    final createdCandidates = results
        .where((e) => e["status"] == "created")
        .toList();

    final progress = result["progress"] ?? {};
    final stats = result["stats"] ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text("Upload Results")),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ////////////////////////////////////////////////////////////
            /// STATS
            ////////////////////////////////////////////////////////////
            Text("Summary", style: theme.textTheme.titleLarge),

            const SizedBox(height: 12),

            Wrap(
              spacing: 16,
              runSpacing: 10,
              children: [
                _stat("Total", progress["total"] ?? 0),
                _stat("Created", stats["created"] ?? 0, Colors.green),
                _stat("Duplicate", stats["duplicate"] ?? 0, Colors.orange),
                _stat("Skipped", stats["skipped"] ?? 0, Colors.blue),
                _stat("Error", stats["error"] ?? 0, Colors.red),
              ],
            ),

            const SizedBox(height: 30),

            ////////////////////////////////////////////////////////////
            /// LIST HEADER
            ////////////////////////////////////////////////////////////
            Text(
              "Created Candidates (${createdCandidates.length})",
              style: theme.textTheme.titleMedium,
            ),

            const SizedBox(height: 10),

            ////////////////////////////////////////////////////////////
            /// LIST
            ////////////////////////////////////////////////////////////
            Expanded(
              child: createdCandidates.isEmpty
                  ? const Center(child: Text("No candidates created"))
                  : ListView.builder(
                      itemCount: createdCandidates.length,
                      itemBuilder: (_, index) {
                        final item = createdCandidates[index];

                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),

                              ////////////////////////////////////////////////////////////
                              /// AVATAR
                              ////////////////////////////////////////////////////////////
                              leading: CircleAvatar(
                                backgroundColor: Colors.green.withOpacity(.1),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.green,
                                ),
                              ),

                              ////////////////////////////////////////////////////////////
                              /// NAME
                              ////////////////////////////////////////////////////////////
                              title: Text(
                                item["name"] ?? "Candidate",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              ////////////////////////////////////////////////////////////
                              /// EMAIL + PHONE
                              ////////////////////////////////////////////////////////////
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (item["email"] != null &&
                                      item["email"].toString().isNotEmpty)
                                    Text(item["email"]),

                                  if (item["phone"] != null &&
                                      item["phone"].toString().isNotEmpty)
                                    Text(
                                      item["phone"],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                ],
                              ),

                              ////////////////////////////////////////////////////////////
                              /// NAVIGATION
                              ////////////////////////////////////////////////////////////
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                              ),

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CandidateDetailScreen(
                                      candidateId: item["candidateId"],
                                    ),
                                  ),
                                );
                              },
                            ),

                            const Divider(height: 1),
                          ],
                        );
                      },
                    ),
            ),

            ////////////////////////////////////////////////////////////
            /// ACTIONS
            ////////////////////////////////////////////////////////////
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Back"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// STAT CARD
  ////////////////////////////////////////////////////////////
  Widget _stat(String label, int value, [Color? color]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: (color ?? Colors.grey).withOpacity(.1),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}
