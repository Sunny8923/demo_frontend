import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend/features/dashboard/partner/presentation/widgets/partner_dashboard_summary_card.dart';
import 'package:gap/gap.dart';

import '../../../../../core/ui/app_scaffold.dart';

import '../../../../auth/presentation/providers/current_user_provider.dart';
import '../../../../partners/presentation/providers/partner_me_provider.dart';

import '../providers/partner_dashboard_provider.dart';

import '../widgets/partner_dashboard_header.dart';
import '../widgets/partner_dashboard_quick_actions.dart';

class PartnerDashboardScreen extends ConsumerWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////
    /// WATCH USER & PARTNER
    ////////////////////////////////////////////////////////////

    final user = ref.watch(currentUserProvider).value;
    final partner = ref.watch(partnerMeProvider).value;

    ////////////////////////////////////////////////////////////
    /// INVALIDATE DASHBOARD IF USER CHANGES
    ////////////////////////////////////////////////////////////

    ref.listen(currentUserProvider, (previous, next) {
      final previousId = previous?.value?.id;
      final nextId = next.value?.id;

      if (previousId != null && nextId != null && previousId != nextId) {
        ref.invalidate(partnerDashboardProvider);
      }
    });

    ////////////////////////////////////////////////////////////
    /// WATCH DASHBOARD
    ////////////////////////////////////////////////////////////

    final dashboardState = ref.watch(partnerDashboardProvider);

    ////////////////////////////////////////////////////////////
    /// UI
    ////////////////////////////////////////////////////////////

    return AppScaffold(
      title: "Partner Dashboard",

      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(partnerDashboardProvider.notifier).refresh();
        },

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: dashboardState.when(
              ////////////////////////////////////////////////////////////
              /// LOADING
              ////////////////////////////////////////////////////////////
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),

              ////////////////////////////////////////////////////////////
              /// ERROR
              ////////////////////////////////////////////////////////////
              error: (error, stack) => Column(
                children: [
                  const Gap(40),

                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.redAccent,
                  ),

                  const Gap(12),

                  const Text("Failed to load dashboard"),

                  const Gap(12),

                  ElevatedButton(
                    onPressed: () {
                      ref.read(partnerDashboardProvider.notifier).refresh();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),

              ////////////////////////////////////////////////////////////
              /// SUCCESS
              ////////////////////////////////////////////////////////////
              data: (dashboard) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ////////////////////////////////////////////////////////
                    /// HEADER
                    ////////////////////////////////////////////////////////
                    PartnerDashboardHeader(
                      partnerName: user?.name ?? "Partner",
                      range: dashboard.range,
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),

                    const Gap(24),

                    ////////////////////////////////////////////////////////
                    /// SUMMARY CARDS
                    ////////////////////////////////////////////////////////
                    PartnerDashboardSummaryCards(
                      dashboard: dashboard,
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: .1),

                    const Gap(24),

                    ////////////////////////////////////////////////////////
                    /// QUICK ACTIONS
                    ////////////////////////////////////////////////////////
                    const PartnerDashboardQuickActions()
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: .1),

                    const Gap(24),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
