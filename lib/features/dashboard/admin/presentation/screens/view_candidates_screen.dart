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

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ////////////////////////////////////////////////////////////
            /// 🔥 FILTER BAR (COMPACT + BACK BUTTON)
            ////////////////////////////////////////////////////////////
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ////////////////////////////////////////////////////////////
                  /// BACK BUTTON (LEFT FIXED)
                  ////////////////////////////////////////////////////////////
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),

                  const SizedBox(width: 40),

                  ////////////////////////////////////////////////////////////
                  /// FILTERS (WRAP TAKES REST SPACE)
                  ////////////////////////////////////////////////////////////
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search...",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: theme.colorScheme.surfaceVariant
                                  .withOpacity(.3),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: notifier.setSearch,
                          ),
                        ),

                        _dropdown(
                          context,
                          hint: "Min Exp",
                          value: state.minExperience,
                          items: const [0, 1, 2, 5],
                          onChanged: notifier.setMinExperience,
                        ),

                        _dropdown(
                          context,
                          hint: "Max Exp",
                          value: state.maxExperience,
                          items: const [1, 2, 5, 10],
                          onChanged: notifier.setMaxExperience,
                        ),

                        SizedBox(
                          width: 120,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Location",
                              filled: true,
                              fillColor: theme.colorScheme.surfaceVariant
                                  .withOpacity(.3),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: notifier.setLocation,
                          ),
                        ),

                        SizedBox(
                          width: 120,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Skills",
                              filled: true,
                              fillColor: theme.colorScheme.surfaceVariant
                                  .withOpacity(.3),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: notifier.setSkills,
                          ),
                        ),

                        OutlinedButton(
                          onPressed: notifier.reset,
                          child: const Text("Reset"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Gap(10),

            ////////////////////////////////////////////////////////////
            /// HEADER
            ////////////////////////////////////////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Candidates",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("${state.total} results"),
              ],
            ),

            const Gap(8),

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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
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
                          /// LIST (MAX HEIGHT NOW)
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
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
                        ],
                      ),
              ),
            ),

            ////////////////////////////////////////////////////////////
            /// PAGINATION (MOVED OUTSIDE 🔥)
            ////////////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Page ${state.page} of ${state.totalPages}"),
                  const Gap(8),
                  IconButton(
                    onPressed: state.page > 1 ? notifier.prevPage : null,
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
