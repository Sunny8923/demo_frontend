import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/candidate_upload_repository.dart';

final candidateUploadRepositoryProvider = Provider(
  (ref) => CandidateUploadRepository(),
);

final resumeUploadProvider =
    AsyncNotifierProvider<ResumeUploadNotifier, String?>(
      ResumeUploadNotifier.new,
    );

class ResumeUploadNotifier extends AsyncNotifier<String?> {
  CandidateUploadRepository get _repo =>
      ref.read(candidateUploadRepositoryProvider);

  @override
  Future<String?> build() async {
    return null;
  }

  ////////////////////////////////////////////////////////////
  /// UPLOAD
  ////////////////////////////////////////////////////////////

  Future<String> upload(List<dynamic> files) async {
    print("PROVIDER: Upload started");

    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      final jobId = await _repo.uploadResumes(files);
      print("PROVIDER: Upload success, jobId = $jobId");
      return jobId;
    });

    state = result;

    if (result.hasError) {
      print("PROVIDER: Upload failed → ${result.error}");
    }

    return result.value!;
  }
}
