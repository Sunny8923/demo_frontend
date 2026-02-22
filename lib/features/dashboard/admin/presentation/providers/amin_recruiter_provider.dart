import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/data/repository/admin_recruiter_repo.dart';

////////////////////////////////////////////////////////////
/// REPOSITORY PROVIDER
////////////////////////////////////////////////////////////

final adminRecruiterRepositoryProvider = Provider<AdminRecruiterRepository>((
  ref,
) {
  return AdminRecruiterRepository();
});

////////////////////////////////////////////////////////////
/// STATE
////////////////////////////////////////////////////////////

class AdminRecruiterState {
  final bool loading;
  final String? error;
  final bool success;

  const AdminRecruiterState({
    this.loading = false,
    this.error,
    this.success = false,
  });

  AdminRecruiterState copyWith({bool? loading, String? error, bool? success}) {
    return AdminRecruiterState(
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
    );
  }
}

////////////////////////////////////////////////////////////
/// NOTIFIER (Riverpod 3 style)
////////////////////////////////////////////////////////////

class AdminRecruiterNotifier extends Notifier<AdminRecruiterState> {
  late final AdminRecruiterRepository _repository;

  ////////////////////////////////////////////////////////////
  /// BUILD (required)
  ////////////////////////////////////////////////////////////

  @override
  AdminRecruiterState build() {
    _repository = ref.read(adminRecruiterRepositoryProvider);
    return const AdminRecruiterState();
  }

  ////////////////////////////////////////////////////////////
  /// CREATE RECRUITER
  ////////////////////////////////////////////////////////////

  Future<void> createRecruiter({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print("DEBUG: Provider createRecruiter");

      state = state.copyWith(loading: true, error: null, success: false);

      await _repository.createRecruiter(
        name: name,
        email: email,
        password: password,
      );

      state = state.copyWith(loading: false, success: true);

      print("DEBUG: Recruiter created successfully");
    } catch (e) {
      print("ERROR: Provider createRecruiter → $e");

      state = state.copyWith(
        loading: false,
        error: e.toString(),
        success: false,
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// RESET
  ////////////////////////////////////////////////////////////

  void reset() {
    state = const AdminRecruiterState();
  }
}

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////

final adminRecruiterProvider =
    NotifierProvider<AdminRecruiterNotifier, AdminRecruiterState>(
      AdminRecruiterNotifier.new,
    );
