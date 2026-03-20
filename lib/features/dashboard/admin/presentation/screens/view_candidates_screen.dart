import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/candidate_provider.dart';

class ViewCandidatesScreen extends ConsumerWidget {
  const ViewCandidatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(candidateProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Candidates")),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: state.when(
          ////////////////////////////////////////////////////////////
          /// LOADING
          ////////////////////////////////////////////////////////////
          loading: () => const Center(child: CircularProgressIndicator()),

          ////////////////////////////////////////////////////////////
          /// ERROR
          ////////////////////////////////////////////////////////////
          error: (e, _) => Center(child: Text("Error: $e")),

          ////////////////////////////////////////////////////////////
          /// DATA
          ////////////////////////////////////////////////////////////
          data: (candidates) {
            if (candidates.isEmpty) {
              return const Center(child: Text("No candidates found"));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ////////////////////////////////////////////////////////////
                /// HEADER
                ////////////////////////////////////////////////////////////
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "All Candidates",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "${candidates.length} total",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),

                const Gap(20),

                ////////////////////////////////////////////////////////////
                /// TABLE HEADER
                ////////////////////////////////////////////////////////////
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(.4),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Expanded(flex: 2, child: Text("Name")),
                      Expanded(flex: 2, child: Text("Email")),
                      Expanded(flex: 1, child: Text("Experience")),
                      Expanded(flex: 2, child: Text("Company")),
                      Expanded(flex: 2, child: Text("Designation")),
                    ],
                  ),
                ),

                ////////////////////////////////////////////////////////////
                /// LIST
                ////////////////////////////////////////////////////////////
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(.2)),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),

                    child: ListView.builder(
                      itemCount: candidates.length,
                      itemBuilder: (context, index) {
                        final c = candidates[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(.1),
                              ),
                            ),
                          ),

                          child: Row(
                            children: [
                              ////////////////////////////////////////////////////
                              /// NAME
                              ////////////////////////////////////////////////////
                              Expanded(
                                flex: 2,
                                child: Text(
                                  c["name"] ?? "-",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              ////////////////////////////////////////////////////
                              /// EMAIL
                              ////////////////////////////////////////////////////
                              Expanded(flex: 2, child: Text(c["email"] ?? "-")),

                              ////////////////////////////////////////////////////
                              /// EXPERIENCE
                              ////////////////////////////////////////////////////
                              Expanded(
                                flex: 1,
                                child: Text("${c["totalExperience"] ?? 0} yr"),
                              ),

                              ////////////////////////////////////////////////////
                              /// COMPANY
                              ////////////////////////////////////////////////////
                              Expanded(
                                flex: 2,
                                child: Text(c["currentCompany"] ?? "-"),
                              ),

                              ////////////////////////////////////////////////////
                              /// DESIGNATION
                              ////////////////////////////////////////////////////
                              Expanded(
                                flex: 2,
                                child: Text(c["currentDesignation"] ?? "-"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
