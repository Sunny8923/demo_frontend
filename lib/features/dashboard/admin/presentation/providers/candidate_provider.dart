import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/candidate_repository.dart';

final candidateRepositoryProvider = Provider((ref) => CandidateRepository());

final candidateProvider =
    AsyncNotifierProvider<CandidateNotifier, List<dynamic>>(
      CandidateNotifier.new,
    );

class CandidateNotifier extends AsyncNotifier<List<dynamic>> {
  CandidateRepository get _repo => ref.read(candidateRepositoryProvider);

  @override
  Future<List<dynamic>> build() async {
    return _repo.getCandidates();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.getCandidates());
  }
}
