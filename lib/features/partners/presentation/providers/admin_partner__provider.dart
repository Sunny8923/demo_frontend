import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/partner_model.dart';
import '../../data/repository/partner_repository.dart';
import 'partner_provider.dart';

final pendingPartnerProvider =
    AsyncNotifierProvider<PendingPartnerNotifier, List<PartnerModel>>(
      PendingPartnerNotifier.new,
    );

class PendingPartnerNotifier extends AsyncNotifier<List<PartnerModel>> {
  // ✅ FIX: use getter instead of late final
  PartnerRepository get _repository => ref.read(partnerRepositoryProvider);
  @override
  Future<List<PartnerModel>> build() async {
    print("DEBUG: Provider → build() START");

    try {
      final result = await _repository.getPendingPartners();

      print(
        "DEBUG: Provider → build() SUCCESS, partners count: ${result.length}",
      );

      return result;
    } catch (e, stack) {
      print("DEBUG: Provider → build() ERROR: $e");
      print("DEBUG: Provider → STACK: $stack");

      rethrow;
    }
  }

  Future<void> approve(String partnerId) async {
    print("DEBUG: Provider → approve START for $partnerId");

    try {
      await _repository.approvePartner(partnerId);

      print("DEBUG: Provider → approve SUCCESS");

      await refresh();

      print("DEBUG: Provider → refresh SUCCESS");
    } catch (e, stack) {
      print("DEBUG: Provider → approve ERROR: $e");
      print(stack);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _repository.getPendingPartners());
  }
}
