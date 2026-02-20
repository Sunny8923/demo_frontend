import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/partner_dashboard_model.dart';
import '../../data/repository/partner_dashboard_repository.dart';

////////////////////////////////////////////////////////////
/// Repository Provider
////////////////////////////////////////////////////////////

final partnerDashboardRepositoryProvider = Provider(
  (ref) => PartnerDashboardRepository(),
);

////////////////////////////////////////////////////////////
/// Dashboard Provider (FIXED WITH autoDispose)
////////////////////////////////////////////////////////////

final partnerDashboardProvider =
    AsyncNotifierProvider.autoDispose<
      PartnerDashboardNotifier,
      PartnerDashboardModel
    >(PartnerDashboardNotifier.new);

class PartnerDashboardNotifier extends AsyncNotifier<PartnerDashboardModel> {
  late final PartnerDashboardRepository _repository;

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Future<PartnerDashboardModel> build() async {
    print("DEBUG: PartnerDashboardProvider → build()");

    // IMPORTANT: clear state when provider rebuilds
    state = const AsyncLoading();

    _repository = ref.read(partnerDashboardRepositoryProvider);

    final dashboard = await _repository.getDashboard();

    print("DEBUG: PartnerDashboardProvider → SUCCESS");

    return dashboard;
  }

  ////////////////////////////////////////////////////////////
  /// REFRESH (FIXED)
  ////////////////////////////////////////////////////////////

  Future<void> refresh() async {
    print("DEBUG: PartnerDashboardProvider → refresh()");

    final previousState = state;

    state = await AsyncValue.guard(() async {
      return await _repository.getDashboard();
    });

    // restore old data if refresh fails
    if (state.hasError && previousState.hasValue) {
      state = previousState;
    }
  }
}
