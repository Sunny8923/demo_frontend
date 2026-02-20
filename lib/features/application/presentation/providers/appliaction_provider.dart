import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/application_repository.dart';

////////////////////////////////////////////////////////////
/// Repository Provider
////////////////////////////////////////////////////////////

final applicationRepositoryProvider = Provider(
  (ref) => ApplicationRepository(),
);

////////////////////////////////////////////////////////////
/// Apply Job Provider
////////////////////////////////////////////////////////////

final applyJobProvider = AsyncNotifierProvider<ApplyJobNotifier, void>(
  ApplyJobNotifier.new,
);

class ApplyJobNotifier extends AsyncNotifier<void> {
  late final ApplicationRepository _repository;

  @override
  Future<void> build() async {
    _repository = ref.read(applicationRepositoryProvider);
  }

  ////////////////////////////////////////////////////////////
  /// APPLY TO JOB (FIXED TYPES)
  ////////////////////////////////////////////////////////////

  Future<void> apply({
    required String jobId,
    required String name,
    required String email,
    required String phone,

    /// optional profile
    String? currentLocation,
    String? totalExperience,
    String? currentCompany,
    String? currentDesignation,
    String? expectedSalary,
    String? noticePeriodDays,
    String? skills,
    String? highestQualification,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.applyToJob(
        jobId: jobId,
        name: name,
        email: email,
        phone: phone,
        currentLocation: currentLocation,
        totalExperience: totalExperience,
        currentCompany: currentCompany,
        currentDesignation: currentDesignation,
        expectedSalary: expectedSalary,
        noticePeriodDays: noticePeriodDays,
        skills: skills,
        highestQualification: highestQualification,
      );
    });
  }
}
