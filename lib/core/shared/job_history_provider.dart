import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart' as html;

////////////////////////////////////////////////////////////
/// MODEL
////////////////////////////////////////////////////////////

class UploadJob {
  final String jobId;
  final int createdAt;

  UploadJob({required this.jobId, required this.createdAt});

  Map<String, dynamic> toJson() => {"jobId": jobId, "createdAt": createdAt};

  factory UploadJob.fromJson(Map<String, dynamic> json) {
    return UploadJob(jobId: json["jobId"], createdAt: json["createdAt"]);
  }
}

////////////////////////////////////////////////////////////
/// NOTIFIER
////////////////////////////////////////////////////////////

class JobHistoryNotifier extends Notifier<List<UploadJob>> {
  static const _storageKey = "resume_job_history";

  @override
  List<UploadJob> build() {
    try {
      final raw = html.window.localStorage[_storageKey];
      if (raw == null) return [];

      final decoded = jsonDecode(raw) as List;

      return decoded.map((e) => UploadJob.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  ////////////////////////////////////////////////////////////
  /// ADD NEW JOB
  ////////////////////////////////////////////////////////////

  void addJob(String jobId) {
    // avoid duplicates
    if (state.any((e) => e.jobId == jobId)) return;

    final newJob = UploadJob(
      jobId: jobId,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    state = [newJob, ...state];
    _persist();
  }
  ////////////////////////////////////////////////////////////
  /// REMOVE JOB
  ////////////////////////////////////////////////////////////

  void removeJob(String jobId) {
    state = state.where((e) => e.jobId != jobId).toList();
    _persist();
  }

  ////////////////////////////////////////////////////////////
  /// SAVE
  ////////////////////////////////////////////////////////////

  void _persist() {
    try {
      final jsonList = state.map((e) => e.toJson()).toList();
      html.window.localStorage[_storageKey] = jsonEncode(jsonList);
    } catch (_) {}
  }
}

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////

final jobHistoryProvider =
    NotifierProvider<JobHistoryNotifier, List<UploadJob>>(
      JobHistoryNotifier.new,
    );
