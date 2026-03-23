import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/data/repository/candidate_upload_repository.dart';
import 'package:frontend/features/dashboard/admin/presentation/providers/resume_upload_provider.dart';

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////

final csvUploadProvider = AsyncNotifierProvider<CsvUploadNotifier, String?>(
  CsvUploadNotifier.new,
);

////////////////////////////////////////////////////////////
/// NOTIFIER
////////////////////////////////////////////////////////////

class CsvUploadNotifier extends AsyncNotifier<String?> {
  CandidateUploadRepository get _repo =>
      ref.read(candidateUploadRepositoryProvider);

  @override
  Future<String?> build() async => null;

  ////////////////////////////////////////////////////////////
  /// UPLOAD
  ////////////////////////////////////////////////////////////

  Future<String> upload(dynamic file) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      return await _repo.uploadCsv(file); // now returns jobId
    });

    state = result;

    return result.value!;
  }
}
