import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_scaffold.dart';
import '../../data/models/application_model.dart';
import '../providers/my_application_provider.dart';

class MyApplicationsScreen extends ConsumerStatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  ConsumerState<MyApplicationsScreen> createState() =>
      _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends ConsumerState<MyApplicationsScreen> {
  @override
  void initState() {
    super.initState();

    /// refresh every time screen opens
    Future.microtask(() {
      ref.read(myApplicationProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myApplicationProvider);

    return AppScaffold(
      title: "My Applications",

      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Text(
            "Failed to load applications",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),

        data: (applications) {
          if (applications.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(myApplicationProvider.notifier).refresh(),

            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),

              itemCount: applications.length,

              separatorBuilder: (_, __) => const SizedBox(height: 12),

              itemBuilder: (context, index) {
                final app = applications[index];

                return _MyApplicationCard(app: app);
              },
            ),
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// APPLICATION CARD
////////////////////////////////////////////////////////////

class _MyApplicationCard extends StatelessWidget {
  final ApplicationModel app;

  const _MyApplicationCard({required this.app});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// Job title + status
            Row(
              children: [
                Expanded(
                  child: Text(
                    app.jobTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                _StatusBadge(status: app.displayStatus),
              ],
            ),

            const SizedBox(height: 12),

            /// Candidate name
            Row(
              children: [
                const Icon(Icons.person_outline, size: 18),
                const SizedBox(width: 8),

                Text(
                  app.candidate.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// Email
            Row(
              children: [
                const Icon(Icons.email_outlined, size: 18),
                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    app.candidate.email,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// Phone
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 18),
                const SizedBox(width: 8),

                Text(app.candidate.phone),
              ],
            ),

            const SizedBox(height: 12),

            /// Date
            Text(
              "Applied on ${_formatDate(app.createdAt)}",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.toLocal();

    return "${d.day}/${d.month}/${d.year} • ${d.hour}:${d.minute.toString().padLeft(2, '0')}";
  }
}

////////////////////////////////////////////////////////////
/// STATUS BADGE
////////////////////////////////////////////////////////////

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status.toUpperCase()) {
      case "SCREENING":
      case "CONTACTED":
      case "INTERVIEW_SCHEDULED":
      case "INTERVIEW_COMPLETED":
      case "SHORTLISTED":
        color = Colors.orange;
        break;

      case "REJECTED":
        color = Colors.red;
        break;

      case "HIRED":
      case "OFFER_ACCEPTED":
        color = Colors.green;
        break;

      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
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

        children: [
          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),

          const SizedBox(height: 16),

          Text(
            "No applications yet",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
          ),

          const SizedBox(height: 6),

          Text(
            "Apply to jobs to see them here",
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
