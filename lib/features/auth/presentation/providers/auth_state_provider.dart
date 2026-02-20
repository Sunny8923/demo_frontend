import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/token_storage.dart';

import '../../../dashboard/user/presentation/providers/user_dashboard_provider.dart';
import '../../../dashboard/admin/presentation/providers/admin_dashboard_provider.dart';
import '../../../dashboard/partner/presentation/providers/partner_dashboard_provider.dart';
import '../../../partners/presentation/providers/partner_me_provider.dart';
import 'current_user_provider.dart';

final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, bool>(
  AuthStateNotifier.new,
);

class AuthStateNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final token = await TokenStorage.getToken();
    return token != null;
  }

  ////////////////////////////////////////////////////////////
  /// PRODUCTION LOGOUT (FULL RESET)
  ////////////////////////////////////////////////////////////

  Future<void> logout() async {
    print("DEBUG: LOGOUT STARTED");

    // 1. Clear token
    await TokenStorage.clearToken();

    // 2. Invalidate ALL user-related providers
    ref.invalidate(currentUserProvider);

    ref.invalidate(userDashboardProvider);
    ref.invalidate(adminDashboardProvider);
    ref.invalidate(partnerDashboardProvider);

    ref.invalidate(partnerMeProvider);

    // 3. Update auth state
    state = const AsyncData(false);

    print("DEBUG: LOGOUT COMPLETE");
  }

  ////////////////////////////////////////////////////////////
  /// LOGIN SUCCESS
  ////////////////////////////////////////////////////////////

  Future<void> setLoggedIn() async {
    print("DEBUG: LOGIN STATE SET");

    // invalidate user to reload fresh profile
    ref.invalidate(currentUserProvider);

    state = const AsyncData(true);
  }
}
