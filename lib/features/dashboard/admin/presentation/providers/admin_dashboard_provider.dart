import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import 'package:frontend/features/dashboard/admin/data/repository/admin_dashboard_repository.dart';

////////////////////////////////////////////////////////////
/// Repository Provider
////////////////////////////////////////////////////////////

final adminDashboardRepositoryProvider = Provider<AdminDashboardRepository>((
  ref,
) {
  return AdminDashboardRepository();
});

////////////////////////////////////////////////////////////
/// Dashboard Provider (FIXED WITH autoDispose)
////////////////////////////////////////////////////////////

final adminDashboardProvider =
    AsyncNotifierProvider.autoDispose<
      AdminDashboardNotifier,
      AdminDashboardModel
    >(AdminDashboardNotifier.new);

class AdminDashboardNotifier extends AsyncNotifier<AdminDashboardModel> {
  late final AdminDashboardRepository _repository;

  ////////////////////////////////////////////////////////////
  /// BUILD (AUTO CALLED)
  ////////////////////////////////////////////////////////////

  @override
  Future<AdminDashboardModel> build() async {
    print("DEBUG: AdminDashboardProvider → build()");

    _repository = ref.read(adminDashboardRepositoryProvider);

    try {
      final stats = await _repository.getDashboardStats();

      print("DEBUG: Jobs count: ${stats.totalJobs}");
      print("DEBUG: Applications count: ${stats.totalApplications}");

      return stats;
    } catch (e, stack) {
      print("DEBUG: AdminDashboardProvider ERROR: $e");
      print("DEBUG: STACK: $stack");

      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  /// REFRESH (FIXED — NO invalidate, NO flicker)
  ////////////////////////////////////////////////////////////

  Future<void> refresh() async {
    print("DEBUG: AdminDashboardProvider → refresh()");

    final previousState = state;

    state = await AsyncValue.guard(() async {
      return await _repository.getDashboardStats();
    });

    // restore old data if refresh fails
    if (state.hasError && previousState.hasValue) {
      state = previousState;
    }
  }
}
