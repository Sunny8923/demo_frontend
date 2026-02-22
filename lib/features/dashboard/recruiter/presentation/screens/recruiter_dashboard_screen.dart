import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/ui/app_scaffold.dart';
import 'package:frontend/features/auth/presentation/providers/current_user_provider.dart';
import 'package:frontend/features/dashboard/recruiter/presentation/widgets/recruiter_quick_actions_card.dart';
import 'package:frontend/features/dashboard/recruiter/presentation/widgets/recruiter_summary_cards.dart';
import '../providers/recruiter_dashboard_provider.dart';
import '../widgets/recruiter_dashboard_header.dart';

class RecruiterDashboardScreen extends ConsumerWidget {
  const RecruiterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final dashboardState = ref.watch(recruiterDashboardProvider);

    return AppScaffold(
      title: "Recruiter Dashboard",

      body: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => const Center(child: Text("Failed to load dashboard")),

        data: (dashboard) {
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(recruiterDashboardProvider.notifier).refresh(),

            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  RecruiterDashboardHeader(name: user?.name ?? "Recruiter"),

                  const SizedBox(height: 24),

                  RecruiterDashboardSummaryCards(dashboard: dashboard),

                  const SizedBox(height: 24),

                  const RecruiterDashboardQuickActions(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
