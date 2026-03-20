import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/job_status_repository.dart';

////////////////////////////////////////////////////////////
/// REPOSITORY
////////////////////////////////////////////////////////////

final jobStatusRepositoryProvider = Provider((ref) => JobStatusRepository());

////////////////////////////////////////////////////////////
/// NOTIFIER
////////////////////////////////////////////////////////////

class JobStatusNotifier extends AsyncNotifier<Map<String, dynamic>> {
  Timer? _timer;
  String? _jobId;

  JobStatusRepository get _repo => ref.read(jobStatusRepositoryProvider);

  ////////////////////////////////////////////////////////////
  /// PUBLIC METHOD (SET JOB ID)
  ////////////////////////////////////////////////////////////

  Future<void> start(String jobId) async {
    _jobId = jobId;

    state = const AsyncLoading();

    try {
      final data = await _repo.getStatus(jobId);
      state = AsyncData(data);

      _startPolling();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  ////////////////////////////////////////////////////////////
  /// BUILD (EMPTY)
  ////////////////////////////////////////////////////////////

  @override
  Future<Map<String, dynamic>> build() async {
    // empty initial state
    return {};
  }

  ////////////////////////////////////////////////////////////
  /// POLLING
  ////////////////////////////////////////////////////////////

  void _startPolling() {
    if (_timer != null || _jobId == null) return;

    _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      try {
        final data = await _repo.getStatus(_jobId!);
        state = AsyncData(data);

        if (data["status"] == "completed") {
          _timer?.cancel();
          _timer = null;
        }
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    });

    ref.onDispose(() {
      _timer?.cancel();
    });
  }
}

////////////////////////////////////////////////////////////
/// PROVIDER (NO FAMILY)
////////////////////////////////////////////////////////////

final jobStatusProvider =
    AsyncNotifierProvider<JobStatusNotifier, Map<String, dynamic>>(
      JobStatusNotifier.new,
    );
