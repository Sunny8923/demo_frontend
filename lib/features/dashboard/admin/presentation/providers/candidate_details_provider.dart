import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/candidate_model.dart';
import '../../data/repository/candidate_repository.dart';

final candidateRepositoryProvider = Provider((ref) => CandidateRepository());

////////////////////////////////////////////////////////////
/// PROVIDER (FAMILY)
////////////////////////////////////////////////////////////

final candidateDetailProvider = FutureProvider.family<Candidate, String>((
  ref,
  id,
) async {
  final repo = ref.read(candidateRepositoryProvider);
  return repo.getCandidateById(id);
});
