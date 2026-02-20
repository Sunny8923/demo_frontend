import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/jobs/data/repository/job_repository.dart';
import '../../data/models/job_model.dart';

/// repository provider
final jobRepositoryProvider = Provider((ref) => JobRepository());

/// create job provider
final createJobProvider = AsyncNotifierProvider<CreateJobNotifier, JobModel?>(
  CreateJobNotifier.new,
);

class CreateJobNotifier extends AsyncNotifier<JobModel?> {
  late final JobRepository _repository;

  @override
  Future<JobModel?> build() async {
    _repository = ref.read(jobRepositoryProvider);

    return null;
  }

  Future<JobModel?> createJob({
    required String title,
    required String companyName,
    required String location,

    String? jrCode,
    String? description,
    String? department,

    int? minExperience,
    int? maxExperience,

    int? salaryMin,
    int? salaryMax,

    int? openings,

    String? skills,
    String? education,

    String? status,

    DateTime? requestDate,
    DateTime? closureDate,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final job = await _repository.createJob(
        jrCode: jrCode,
        title: title,
        description: description,
        companyName: companyName,
        department: department,
        location: location,
        minExperience: minExperience,
        maxExperience: maxExperience,
        salaryMin: salaryMin,
        salaryMax: salaryMax,
        openings: openings,
        skills: skills,
        education: education,
        status: status,
        requestDate: requestDate,
        closureDate: closureDate,
      );

      return job;
    });

    return state.value;
  }

  void reset() {
    state = const AsyncData(null);
  }
}
