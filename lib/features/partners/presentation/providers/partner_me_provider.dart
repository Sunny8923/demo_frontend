import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/partner_model.dart';
import '../../data/repository/partner_repository.dart';
import 'partner_provider.dart';

final partnerMeProvider =
    AsyncNotifierProvider<PartnerMeNotifier, PartnerModel?>(
      PartnerMeNotifier.new,
    );

class PartnerMeNotifier extends AsyncNotifier<PartnerModel?> {
  // ✅ FIX: use getter instead of late final
  PartnerRepository get _repository => ref.read(partnerRepositoryProvider);

  @override
  Future<PartnerModel?> build() async {
    try {
      return await _repository.getMyPartnerProfile();
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        // partner exists but not approved yet
        return null;
      }

      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _repository.getMyPartnerProfile());
  }
}
