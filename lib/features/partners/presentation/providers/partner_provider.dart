import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/partner_repository.dart';

final partnerRepositoryProvider = Provider((ref) => PartnerRepository());

final partnerRequestProvider =
    AsyncNotifierProvider<PartnerRequestNotifier, void>(
      PartnerRequestNotifier.new,
    );

class PartnerRequestNotifier extends AsyncNotifier<void> {
  // ✅ FIX: use getter instead of late final
  PartnerRepository get _repository => ref.read(partnerRepositoryProvider);

  @override
  Future<void> build() async {
    // nothing required here
  }

  Future<void> requestAccess({
    required String businessName,
    required String phone,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.requestPartnerAccess(
        businessName: businessName,
        phone: phone,
      );
    });
  }
}
