import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/auth_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authProvider = AsyncNotifierProvider<AuthNotifier, void>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<void> {
  // ✅ FIX: use getter instead of late final
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  Future<void> build() async {
    // nothing required here
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.login(email, password);
    });
  }

  Future<void> signup(String name, String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.signup(name, email, password);
    });
  }

  Future<void> partnerSignup({
    required String name,
    required String email,
    required String password,

    required String organisationName,
    required String ownerName,
    required String establishmentDate,

    required String gstNumber,
    required String panNumber,

    required String address,

    required String contactNumber,

    required String officialEmail,

    required bool msmeRegistered,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.partnerSignup(
        name: name,
        email: email,
        password: password,

        organisationName: organisationName,
        ownerName: ownerName,
        establishmentDate: establishmentDate,

        gstNumber: gstNumber,
        panNumber: panNumber,

        address: address,

        contactNumber: contactNumber,

        officialEmail: officialEmail,

        msmeRegistered: msmeRegistered,
      );
    });
  }
}
