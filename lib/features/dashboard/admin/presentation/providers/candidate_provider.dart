import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/candidate_model.dart';
import '../../data/repository/candidate_repository.dart';

////////////////////////////////////////////////////////////
/// REPOSITORY
////////////////////////////////////////////////////////////

final candidateRepositoryProvider = Provider((ref) => CandidateRepository());

////////////////////////////////////////////////////////////
/// STATE
////////////////////////////////////////////////////////////

class CandidateState {
  final List<Candidate> candidates;
  final int page;
  final int totalPages;
  final int total;
  final bool loading;

  final String search;
  final double? minExperience;

  CandidateState({
    this.candidates = const [],
    this.page = 1,
    this.totalPages = 1,
    this.total = 0,
    this.loading = false,
    this.search = "",
    this.minExperience,
  });

  CandidateState copyWith({
    List<Candidate>? candidates,
    int? page,
    int? totalPages,
    int? total,
    bool? loading,
    String? search,
    double? minExperience,
  }) {
    return CandidateState(
      candidates: candidates ?? this.candidates,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      loading: loading ?? this.loading,
      search: search ?? this.search,
      minExperience: minExperience ?? this.minExperience,
    );
  }
}

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////

final candidateProvider = NotifierProvider<CandidateNotifier, CandidateState>(
  CandidateNotifier.new,
);

////////////////////////////////////////////////////////////
/// NOTIFIER
////////////////////////////////////////////////////////////

class CandidateNotifier extends Notifier<CandidateState> {
  CandidateRepository get _repo => ref.read(candidateRepositoryProvider);

  @override
  CandidateState build() {
    // initial load
    Future.microtask(() => loadCandidates());
    return CandidateState();
  }

  ////////////////////////////////////////////////////////////
  /// LOAD DATA (CORE FUNCTION)
  ////////////////////////////////////////////////////////////

  Future<void> loadCandidates({int? page}) async {
    state = state.copyWith(loading: true);

    try {
      final res = await _repo.getCandidates(
        search: state.search,
        minExperience: state.minExperience,
        page: page ?? state.page,
      );

      state = state.copyWith(
        candidates: res.candidates,
        page: res.page,
        totalPages: res.totalPages,
        total: res.total,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false);
    }
  }

  ////////////////////////////////////////////////////////////
  /// SEARCH
  ////////////////////////////////////////////////////////////

  void setSearch(String value) {
    state = state.copyWith(search: value, page: 1);
    loadCandidates(page: 1);
  }

  ////////////////////////////////////////////////////////////
  /// FILTERS
  ////////////////////////////////////////////////////////////

  void setMinExperience(double? value) {
    state = state.copyWith(minExperience: value, page: 1);
    loadCandidates(page: 1);
  }

  ////////////////////////////////////////////////////////////
  /// PAGINATION
  ////////////////////////////////////////////////////////////

  void nextPage() {
    if (state.page < state.totalPages) {
      loadCandidates(page: state.page + 1);
    }
  }

  void prevPage() {
    if (state.page > 1) {
      loadCandidates(page: state.page - 1);
    }
  }

  ////////////////////////////////////////////////////////////
  /// RESET
  ////////////////////////////////////////////////////////////

  void reset() {
    state = CandidateState();
    loadCandidates(page: 1);
  }
}
