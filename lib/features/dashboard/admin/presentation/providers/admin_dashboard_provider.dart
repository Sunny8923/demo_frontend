import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import '../../data/repository/admin_dashboard_repository.dart';

////////////////////////////////////////////////////////////
/// Repository Provider
////////////////////////////////////////////////////////////

final adminDashboardRepositoryProvider = Provider<AdminDashboardRepository>((
  ref,
) {
  return AdminDashboardRepository();
});

////////////////////////////////////////////////////////////
/// Dashboard Provider (PRODUCTION SAFE)
////////////////////////////////////////////////////////////

final adminDashboardProvider =
    AsyncNotifierProvider<AdminDashboardNotifier, AdminDashboardData>(
      AdminDashboardNotifier.new,
    );

class AdminDashboardNotifier extends AsyncNotifier<AdminDashboardData> {
  late final AdminDashboardRepository _repository;

  ////////////////////////////////////////////////////////////
  /// CACHE
  ////////////////////////////////////////////////////////////

  final Map<String, AdminDashboardData> _cache = {};

  ////////////////////////////////////////////////////////////
  /// CURRENT RANGE
  ////////////////////////////////////////////////////////////

  String _currentRange = "7d";

  ////////////////////////////////////////////////////////////
  /// BUILD → INITIAL LOAD
  ////////////////////////////////////////////////////////////

  @override
  Future<AdminDashboardData> build() async {
    _repository = ref.read(adminDashboardRepositoryProvider);

    print("DEBUG: Loading dashboard (initial)");

    try {
      /// preload both ranges for instant switching
      final results = await Future.wait([
        _repository.getDashboardStats(range: "7d"),
        _repository.getDashboardStats(range: "30d"),
      ]);

      _cache["7d"] = results[0];
      _cache["30d"] = results[1];

      print("DEBUG: Dashboard preload complete");

      return _cache[_currentRange]!;
    } catch (e) {
      print("ERROR loading dashboard: $e");
      throw e;
    }
  }

  ////////////////////////////////////////////////////////////
  /// CHANGE RANGE (INSTANT SWITCH)
  ////////////////////////////////////////////////////////////

  Future<void> changeRange(String range) async {
    if (_currentRange == range) return;

    print("DEBUG: Changing range → $range");

    _currentRange = range;

    /// instant UI update from cache
    if (_cache.containsKey(range)) {
      state = AsyncValue.data(_cache[range]!);

      /// refresh silently in background
      _refreshInBackground(range);
    } else {
      /// fallback if not cached
      state = const AsyncValue.loading();

      try {
        final data = await _repository.getDashboardStats(range: range);

        _cache[range] = data;

        state = AsyncValue.data(data);
      } catch (e, stack) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  ////////////////////////////////////////////////////////////
  /// BACKGROUND REFRESH
  ////////////////////////////////////////////////////////////

  Future<void> _refreshInBackground(String range) async {
    try {
      print("DEBUG: Background refresh → $range");

      final fresh = await _repository.getDashboardStats(range: range);

      _cache[range] = fresh;

      /// update UI only if still active range
      if (_currentRange == range) {
        state = AsyncValue.data(fresh);
      }
    } catch (e) {
      print("DEBUG: Background refresh failed: $e");
    }
  }

  ////////////////////////////////////////////////////////////
  /// MANUAL REFRESH (PULL TO REFRESH SAFE)
  ////////////////////////////////////////////////////////////

  Future<void> refresh() async {
    final range = _currentRange;

    print("DEBUG: Manual refresh → $range");

    try {
      final fresh = await _repository.getDashboardStats(range: range);

      _cache[range] = fresh;

      state = AsyncValue.data(fresh);
    } catch (e, stack) {
      print("ERROR refreshing dashboard: $e");

      state = AsyncValue.error(e, stack);
    }
  }

  ////////////////////////////////////////////////////////////
  /// FORCE FULL RELOAD (OPTIONAL)
  ////////////////////////////////////////////////////////////

  Future<void> reload() async {
    print("DEBUG: Full reload");

    state = const AsyncValue.loading();

    final data = await build();

    state = AsyncValue.data(data);
  }

  ////////////////////////////////////////////////////////////
  /// GET CURRENT RANGE
  ////////////////////////////////////////////////////////////

  String get currentRange => _currentRange;
}
