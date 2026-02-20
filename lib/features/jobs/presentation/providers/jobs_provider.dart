import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/jobs/data/repository/job_repository.dart';
import '../../data/models/job_model.dart';
import 'create_job_provider.dart';

final jobsProvider = AsyncNotifierProvider<JobsNotifier, List<JobModel>>(
  JobsNotifier.new,
);

class JobsNotifier extends AsyncNotifier<List<JobModel>> {
  late final JobRepository _repository;

  @override
  Future<List<JobModel>> build() async {
    _repository = ref.read(jobRepositoryProvider);

    return await _repository.getAllJobs();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await _repository.getAllJobs();
    });
  }
}
