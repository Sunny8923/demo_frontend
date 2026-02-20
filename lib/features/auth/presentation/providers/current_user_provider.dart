import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_model.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_provider.dart';

final currentUserProvider =
    AsyncNotifierProvider<CurrentUserNotifier, UserModel?>(
      CurrentUserNotifier.new,
    );

class CurrentUserNotifier extends AsyncNotifier<UserModel?> {
  // ✅ FIX: use getter instead of late final
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  Future<UserModel?> build() async {
    try {
      return await _repository.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _repository.getCurrentUser());
  }
}
