import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';

import '../../data/repository/admin_dashboard_repository.dart';

final adminDashboardRepositoryProvider = Provider<AdminDashboardRepository>((
  ref,
) {
  return AdminDashboardRepository();
});

////////////////////////////////////////////////////////////
/// Dashboard Provider (FULL ANALYTICS MODEL)
////////////////////////////////////////////////////////////

final adminDashboardProvider =
    AsyncNotifierProvider.autoDispose<
      AdminDashboardNotifier,
      AdminDashboardData
    >(AdminDashboardNotifier.new);

class AdminDashboardNotifier extends AsyncNotifier<AdminDashboardData> {
  late final AdminDashboardRepository _repository;

  ////////////////////////////////////////////////////////////
  /// BUILD (AUTO CALLED)
  ////////////////////////////////////////////////////////////

  @override
  Future<AdminDashboardData> build() async {
    print("DEBUG: AdminDashboardProvider → build()");

    _repository = ref.read(adminDashboardRepositoryProvider);

    try {
      final dashboard = await _repository.getDashboardStats();

      ////////////////////////////////////////////////////////
      /// Debug logs (useful for verification)
      ////////////////////////////////////////////////////////

      print("DEBUG: Range: ${dashboard.range}");

      print("DEBUG: Total Jobs: ${dashboard.summary.totalJobs}");
      print("DEBUG: Open Jobs: ${dashboard.summary.openJobs}");

      print("DEBUG: Total Partners: ${dashboard.summary.totalPartners}");
      print("DEBUG: Pending Partners: ${dashboard.summary.pendingPartners}");

      print(
        "DEBUG: Total Applications: ${dashboard.summary.totalApplications}",
      );

      print("DEBUG: Pipeline stages: ${dashboard.pipeline.stages.length}");

      print(
        "DEBUG: Top partners count: ${dashboard.leaderboards.topPartners.length}",
      );

      print("DEBUG: Trend points: ${dashboard.trends.applications.length}");

      return dashboard;
    } catch (e, stack) {
      print("DEBUG: AdminDashboardProvider ERROR: $e");
      print("DEBUG: STACK: $stack");

      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  /// REFRESH (NO flicker, preserves old state on error)
  ////////////////////////////////////////////////////////////

  Future<void> refresh() async {
    print("DEBUG: AdminDashboardProvider → refresh()");

    final previousState = state;

    state = await AsyncValue.guard(() async {
      return await _repository.getDashboardStats();
    });

    /// restore old data if refresh fails
    if (state.hasError && previousState.hasValue) {
      state = previousState;
    }
  }
}
