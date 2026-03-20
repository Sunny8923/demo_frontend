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
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      return await _repo.uploadResumes(files);
    });

    state = result;

    return result.value!;
  }
}
