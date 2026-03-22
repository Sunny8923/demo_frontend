import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/candidate_provider.dart';
import 'candidate_details_screen.dart';

class ViewCandidatesScreen extends ConsumerWidget {
  const ViewCandidatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(candidateProvider);
    final notifier = ref.read(candidateProvider.notifier);
    final theme = Theme.of(context);

    final candidates = state.candidates;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text("Candidates")),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ////////////////////////////////////////////////////////////
            /// 🔥 FILTER BAR (FIXED)
            ////////////////////////////////////////////////////////////
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(.05),
                  ),
                ],
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ////////////////////////////////////////////////////////////
                  /// SEARCH
                  ////////////////////////////////////////////////////////////
                  SizedBox(
                    width: 220,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search name, email...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant.withOpacity(
                          .3,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: notifier.setSearch,
                    ),
                  ),

                  ////////////////////////////////////////////////////////////
                  /// MIN EXP
                  ////////////////////////////////////////////////////////////
                  _dropdown(
                    context,
                    hint: "Min Exp",
                    value: state.minExperience,
                    items: const [0, 1, 2, 5],
                    onChanged: notifier.setMinExperience,
                  ),

                  ////////////////////////////////////////////////////////////
                  /// MAX EXP
                  ////////////////////////////////////////////////////////////
                  _dropdown(
                    context,
                    hint: "Max Exp",
                    value: state.maxExperience,
                    items: const [1, 2, 5, 10],
                    onChanged: notifier.setMaxExperience,
                  ),

                  ////////////////////////////////////////////////////////////
                  /// LOCATION
                  ////////////////////////////////////////////////////////////
                  SizedBox(
                    width: 140,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Location",
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant.withOpacity(
                          .3,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: notifier.setLocation,
                    ),
                  ),

                  ////////////////////////////////////////////////////////////
                  /// SKILLS
                  ////////////////////////////////////////////////////////////
                  SizedBox(
                    width: 140,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Skills",
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant.withOpacity(
                          .3,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: notifier.setSkills,
                    ),
                  ),

                  ////////////////////////////////////////////////////////////
                  /// RESET
                  ////////////////////////////////////////////////////////////
                  OutlinedButton(
                    onPressed: notifier.reset,
                    child: const Text("Reset"),
                  ),
                ],
              ),
            ),

            const Gap(20),

            ////////////////////////////////////////////////////////////
            /// HEADER
            ////////////////////////////////////////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Candidates",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("${state.total} results"),
              ],
            ),

            const Gap(16),

            ////////////////////////////////////////////////////////////
            /// TABLE
            ////////////////////////////////////////////////////////////
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(.15)),
                ),
                child: state.loading
                    ? const Center(child: CircularProgressIndicator())
                    : candidates.isEmpty
                    ? const _EmptyState()
                    : Column(
                        children: [
                          ////////////////////////////////////////////////////
                          /// HEADER
                          ////////////////////////////////////////////////////
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(.1),
                                ),
                              ),
                            ),
                            child: Row(
                              children: const [
                                Expanded(flex: 2, child: Text("Name")),
                                Expanded(flex: 2, child: Text("Email")),
                                Expanded(flex: 1, child: Text("Exp")),
                                Expanded(flex: 2, child: Text("Company")),
                                Expanded(flex: 2, child: Text("Role")),
                              ],
                            ),
                          ),

                          ////////////////////////////////////////////////////
                          /// LIST
                          ////////////////////////////////////////////////////
                          Expanded(
                            child: ListView.builder(
                              itemCount: candidates.length,
                              itemBuilder: (_, i) {
                                final c = candidates[i];

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CandidateDetailScreen(
                                          candidateId: c.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.withOpacity(.05),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(flex: 2, child: Text(c.name)),
                                        Expanded(flex: 2, child: Text(c.email)),
                                        Expanded(
                                          flex: 1,
                                          child: Text("${c.experience ?? 0}y"),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(c.company ?? "-"),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(c.designation ?? "-"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          ////////////////////////////////////////////////////
                          /// PAGINATION
                          ////////////////////////////////////////////////////
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Page ${state.page} of ${state.totalPages}",
                                ),
                                const Gap(12),
                                IconButton(
                                  onPressed: state.page > 1
                                      ? notifier.prevPage
                                      : null,
                                  icon: const Icon(Icons.chevron_left),
                                ),
                                IconButton(
                                  onPressed: state.page < state.totalPages
                                      ? notifier.nextPage
                                      : null,
                                  icon: const Icon(Icons.chevron_right),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// DROPDOWN (FIXED)
////////////////////////////////////////////////////////////

Widget _dropdown(
  BuildContext context, {
  required String hint,
  required double? value,
  required List<int> items,
  required ValueChanged<double?> onChanged,
}) {
  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: 100, maxWidth: 130),
    child: DropdownButtonFormField<double>(
      isExpanded: true, // 🔥 FIX

      value: value,
      hint: Text(hint, overflow: TextOverflow.ellipsis),

      items: items
          .map((e) => DropdownMenuItem(value: e.toDouble(), child: Text("$e+")))
          .toList(),

      onChanged: onChanged,

      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

////////////////////////////////////////////////////////////
/// EMPTY STATE
////////////////////////////////////////////////////////////

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search_off, size: 50),
          SizedBox(height: 12),
          Text("No candidates found"),
        ],
      ),
    );
  }
}
