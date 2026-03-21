import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/data/repository/candidate_upload_repository.dart';
import 'package:frontend/features/dashboard/admin/presentation/providers/resume_upload_provider.dart';

final csvUploadProvider =
    AsyncNotifierProvider<CsvUploadNotifier, Map<String, dynamic>?>(
      CsvUploadNotifier.new,
    );

class CsvUploadNotifier extends AsyncNotifier<Map<String, dynamic>?> {
  CandidateUploadRepository get _repo =>
      ref.read(candidateUploadRepositoryProvider);

  @override
  Future<Map<String, dynamic>?> build() async => null;

  Future<Map<String, dynamic>> upload(dynamic file) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      return await _repo.uploadCsv(file);
    });

    state = result;

    return result.value!;
  }
}
