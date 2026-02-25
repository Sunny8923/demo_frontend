import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/presentation/providers/auth_state_provider.dart';

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
      final user = await _repository.getCurrentUser();
      return user;
    } catch (e) {
      // ✅ logout if fetch fails (server down, token invalid, etc)
      Future.microtask(() {
        ref.read(authStateProvider.notifier).logout();
      });

      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _repository.getCurrentUser());
  }
}
