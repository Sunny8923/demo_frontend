import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/user/data/repository/user_dashboard_repository.dart';
import '../../data/models/user_dashboard_model.dart';

////////////////////////////////////////////////////////////
/// REPOSITORY PROVIDER
////////////////////////////////////////////////////////////

final userDashboardRepositoryProvider = Provider(
  (ref) => UserDashboardRepository(),
);

////////////////////////////////////////////////////////////
/// DASHBOARD PROVIDER (AUTO DISPOSE FIXED)
////////////////////////////////////////////////////////////

final userDashboardProvider =
    AsyncNotifierProvider.autoDispose<
      UserDashboardNotifier,
      UserDashboardModel
    >(UserDashboardNotifier.new);

class UserDashboardNotifier extends AsyncNotifier<UserDashboardModel> {
  late final UserDashboardRepository _repository;

  ////////////////////////////////////////////////////////////
  /// BUILD (AUTO CALLED FIRST TIME)
  ////////////////////////////////////////////////////////////

  @override
  Future<UserDashboardModel> build() async {
    print("DEBUG: UserDashboardProvider → build() called");

    _repository = ref.read(userDashboardRepositoryProvider);

    try {
      final dashboard = await _repository.getDashboard();

      print("DEBUG: UserDashboardProvider → SUCCESS");
      print("DEBUG: totalApplications = ${dashboard.totalApplications}");

      return dashboard;
    } catch (e, stack) {
      print("DEBUG: UserDashboardProvider → ERROR: $e");
      print("DEBUG: STACK: $stack");

      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  /// MANUAL REFRESH (FIXED — NO FLICKER / NO CRASH)
  ////////////////////////////////////////////////////////////

  Future<void> refresh() async {
    print("DEBUG: UserDashboardProvider → refresh()");

    final previousState = state;

    state = await AsyncValue.guard(() async {
      final dashboard = await _repository.getDashboard();

      print("DEBUG: refresh SUCCESS");

      return dashboard;
    });

    // Optional: if error, restore old data instead of blank screen
    if (state.hasError && previousState.hasValue) {
      state = previousState;
    }
  }
}
