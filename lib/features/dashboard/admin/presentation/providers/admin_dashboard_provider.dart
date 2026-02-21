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
  /// STORE CURRENT RANGE
  ////////////////////////////////////////////////////////////

  String _currentRange = "7d";

  ////////////////////////////////////////////////////////////
  /// BUILD (initial load)
  ////////////////////////////////////////////////////////////

  @override
  Future<AdminDashboardData> build() async {
    print("DEBUG: AdminDashboardProvider → build()");

    _repository = ref.read(adminDashboardRepositoryProvider);

    return _fetchDashboard();
  }

  ////////////////////////////////////////////////////////////
  /// INTERNAL FETCH METHOD
  ////////////////////////////////////////////////////////////

  Future<AdminDashboardData> _fetchDashboard() async {
    print("DEBUG: Fetch dashboard range = $_currentRange");

    final dashboard = await _repository.getDashboardStats(range: _currentRange);

    return dashboard;
  }

  ////////////////////////////////////////////////////////////
  /// SWITCH RANGE (KEY FEATURE)
  ////////////////////////////////////////////////////////////

  Future<void> changeRange(String range) async {
    if (_currentRange == range) return;

    print("DEBUG: Changing range → $range");

    _currentRange = range;

    final previous = state;

    state = await AsyncValue.guard(() async {
      return await _fetchDashboard();
    });

    /// restore previous data if error
    if (state.hasError && previous.hasValue) {
      state = previous;
    }
  }

  ////////////////////////////////////////////////////////////
  /// REFRESH CURRENT RANGE
  ////////////////////////////////////////////////////////////

  Future<void> refresh() async {
    print("DEBUG: Refresh dashboard → $_currentRange");

    final previous = state;

    state = await AsyncValue.guard(() async {
      return await _fetchDashboard();
    });

    if (state.hasError && previous.hasValue) {
      state = previous;
    }
  }

  ////////////////////////////////////////////////////////////
  /// GET CURRENT RANGE (for UI)
  ////////////////////////////////////////////////////////////

  String get currentRange => _currentRange;
}
