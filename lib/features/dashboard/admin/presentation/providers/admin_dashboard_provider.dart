import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import '../../data/repository/admin_dashboard_repository.dart';

final adminDashboardRepositoryProvider = Provider<AdminDashboardRepository>((
  ref,
) {
  return AdminDashboardRepository();
});

////////////////////////////////////////////////////////////
/// Dashboard Provider (ULTRA SMOOTH RANGE SWITCH)
////////////////////////////////////////////////////////////

final adminDashboardProvider =
    AsyncNotifierProvider.autoDispose<
      AdminDashboardNotifier,
      AdminDashboardData
    >(AdminDashboardNotifier.new);

class AdminDashboardNotifier extends AsyncNotifier<AdminDashboardData> {
  late final AdminDashboardRepository _repository;

  ////////////////////////////////////////////////////////////
  /// CACHE FOR BOTH RANGES
  ////////////////////////////////////////////////////////////

  final Map<String, AdminDashboardData> _cache = {};

  ////////////////////////////////////////////////////////////
  /// CURRENT RANGE
  ////////////////////////////////////////////////////////////

  String _currentRange = "7d";

  ////////////////////////////////////////////////////////////
  /// BUILD → PRELOAD BOTH RANGES
  ////////////////////////////////////////////////////////////

  @override
  Future<AdminDashboardData> build() async {
    _repository = ref.read(adminDashboardRepositoryProvider);

    print("DEBUG: Preloading dashboard ranges");

    /// Fetch both ranges in parallel
    final results = await Future.wait([
      _repository.getDashboardStats(range: "7d"),
      _repository.getDashboardStats(range: "30d"),
    ]);

    /// Store in cache
    _cache["7d"] = results[0];
    _cache["30d"] = results[1];

    print("DEBUG: Preload complete");

    /// Return default
    return _cache[_currentRange]!;
  }

  ////////////////////////////////////////////////////////////
  /// CHANGE RANGE (INSTANT SWITCH)
  ////////////////////////////////////////////////////////////

  Future<void> changeRange(String range) async {
    if (_currentRange == range) return;

    print("DEBUG: Switching range instantly → $range");

    _currentRange = range;

    /// Instant switch from cache (NO LOADING STATE)
    if (_cache.containsKey(range)) {
      state = AsyncValue.data(_cache[range]!);

      /// Refresh silently in background
      _refreshInBackground(range);
    } else {
      /// fallback (rare case)
      state = const AsyncValue.loading();

      final data = await _repository.getDashboardStats(range: range);

      _cache[range] = data;

      state = AsyncValue.data(data);
    }
  }

  ////////////////////////////////////////////////////////////
  /// BACKGROUND REFRESH (NO UI BLOCK)
  ////////////////////////////////////////////////////////////

  Future<void> _refreshInBackground(String range) async {
    try {
      print("DEBUG: Background refresh → $range");

      final fresh = await _repository.getDashboardStats(range: range);

      _cache[range] = fresh;

      /// update UI only if still same range
      if (_currentRange == range) {
        state = AsyncValue.data(fresh);
      }
    } catch (_) {
      print("DEBUG: Background refresh failed (ignored)");
    }
  }

  ////////////////////////////////////////////////////////////
  /// MANUAL REFRESH
  ////////////////////////////////////////////////////////////

  Future<void> refresh() async {
    final range = _currentRange;

    print("DEBUG: Manual refresh → $range");

    final fresh = await _repository.getDashboardStats(range: range);

    _cache[range] = fresh;

    state = AsyncValue.data(fresh);
  }

  ////////////////////////////////////////////////////////////
  /// GET CURRENT RANGE
  ////////////////////////////////////////////////////////////

  String get currentRange => _currentRange;
}
