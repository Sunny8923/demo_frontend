import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/application/presentation/widgets/application_list_card.dart';
import '../../../../core/ui/app_scaffold.dart';
import '../providers/admin_application_provider.dart';

class AdminApplicationsScreen extends ConsumerWidget {
  const AdminApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminApplicationProvider);

    return AppScaffold(
      title: "Applications",

      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (_, __) => const _ErrorState(),

        data: (applications) {
          if (applications.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(adminApplicationProvider.notifier).refresh(),

            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: applications.length,

              itemBuilder: (_, index) {
                final app = applications[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: ApplicationListCard(app: app),
                );
              },
            ),
          );
        },
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
            "No Applications",
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 6),

          Text(
            "Applications will appear here",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// ERROR STATE
////////////////////////////////////////////////////////////

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Failed to load applications",
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
