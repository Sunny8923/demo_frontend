import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/data/model/job_status_model.dart';
import '../../data/repository/job_status_repository.dart';

////////////////////////////////////////////////////////////
/// REPOSITORY
////////////////////////////////////////////////////////////

final jobStatusRepositoryProvider = Provider((ref) => JobStatusRepository());

////////////////////////////////////////////////////////////
/// NOTIFIER
////////////////////////////////////////////////////////////

class JobStatusNotifier extends AsyncNotifier<JobStatus> {
  Timer? _timer;
  String? _jobId;

  bool _isFetching = false;
  bool _started = false;

  JobStatusRepository get _repo => ref.read(jobStatusRepositoryProvider);

  ////////////////////////////////////////////////////////////
  /// START
  ////////////////////////////////////////////////////////////

  Future<void> start(String jobId) async {
    if (_started && _jobId == jobId) return;

    _started = true;
    _jobId = jobId;

    state = const AsyncLoading();

    try {
      final res = await _repo.getStatus(jobId);

      final jobStatus = JobStatus.fromJson(res);

      state = AsyncData(jobStatus);

      _startPolling();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  ////////////////////////////////////////////////////////////
  /// BUILD (IMPORTANT FIX)
  ////////////////////////////////////////////////////////////

  @override
  Future<JobStatus> build() async {
    return JobStatus(
      status: "",
      total: 0,
      processed: 0,
      percentage: 0,
      created: 0,
      duplicate: 0,
      skipped: 0,
      error: 0,
      currentFile: "",
      completed: false,
      remaining: 0,
      results: [],

      ////////////////////////////////////////////////////////////
      /// REQUIRED (NEW)
      ////////////////////////////////////////////////////////////
      rawResponse: {},
    );
  }

  ////////////////////////////////////////////////////////////
  /// POLLING
  ////////////////////////////////////////////////////////////

  void _startPolling() {
    if (_timer != null || _jobId == null) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (_isFetching) return;

      _isFetching = true;

      try {
        final res = await _repo.getStatus(_jobId!);

        final jobStatus = JobStatus.fromJson(res);

        state = AsyncData(jobStatus);

        if (jobStatus.completed) {
          _timer?.cancel();
          _timer = null;
        }
      } catch (e) {
        print("Polling error (ignored): $e");
      } finally {
        _isFetching = false;
      }
    });

    ////////////////////////////////////////////////////////////
    /// CLEANUP
    ////////////////////////////////////////////////////////////
    ref.onDispose(() {
      _timer?.cancel();
    });
  }
}

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////

final jobStatusProvider = AsyncNotifierProvider<JobStatusNotifier, JobStatus>(
  JobStatusNotifier.new,
);
