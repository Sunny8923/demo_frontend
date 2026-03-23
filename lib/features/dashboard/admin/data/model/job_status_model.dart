class JobStatus {
  final String status;

  final int total;
  final int processed;
  final int percentage;

  final int created;
  final int duplicate;
  final int skipped;
  final int error;

  final String currentFile;

  final bool completed;
  final int remaining;

  final List<JobResult> results;

  ////////////////////////////////////////////////////////////
  /// NEW: RAW RESPONSE (IMPORTANT)
  ////////////////////////////////////////////////////////////
  final Map<String, dynamic> rawResponse;

  JobStatus({
    required this.status,
    required this.total,
    required this.processed,
    required this.percentage,
    required this.created,
    required this.duplicate,
    required this.skipped,
    required this.error,
    required this.currentFile,
    required this.completed,
    required this.remaining,
    required this.results,
    required this.rawResponse,
  });

  factory JobStatus.fromJson(Map<String, dynamic> json) {
    ////////////////////////////////////////////////////////////
    /// SAFE RESULTS PARSING (FIX)
    ////////////////////////////////////////////////////////////

    final rawResults = json["results"];

    List<JobResult> parsedResults = [];

    if (rawResults is List) {
      parsedResults = rawResults.map((e) => JobResult.fromJson(e)).toList();
    }

    return JobStatus(
      status: json["status"] ?? "",

      ////////////////////////////////////////////////////////////
      /// PROGRESS
      ////////////////////////////////////////////////////////////
      total: json["progress"]?["total"] ?? 0,
      processed: json["progress"]?["processed"] ?? 0,
      percentage: json["progress"]?["percentage"] ?? 0,

      ////////////////////////////////////////////////////////////
      /// STATS
      ////////////////////////////////////////////////////////////
      created: json["stats"]?["created"] ?? 0,
      duplicate: json["stats"]?["duplicate"] ?? 0,
      skipped: json["stats"]?["skipped"] ?? 0,
      error: json["stats"]?["error"] ?? 0,

      ////////////////////////////////////////////////////////////
      /// ACTIVITY
      ////////////////////////////////////////////////////////////
      currentFile: json["activity"]?["currentFile"] ?? "",

      ////////////////////////////////////////////////////////////
      /// SUMMARY
      ////////////////////////////////////////////////////////////
      completed: json["summary"]?["completed"] ?? false,
      remaining: json["summary"]?["remaining"] ?? 0,

      ////////////////////////////////////////////////////////////
      /// RESULTS (SAFE)
      ////////////////////////////////////////////////////////////
      results: parsedResults,

      ////////////////////////////////////////////////////////////
      /// RAW RESPONSE (IMPORTANT)
      ////////////////////////////////////////////////////////////
      rawResponse: json,
    );
  }
}

////////////////////////////////////////////////////////////
/// RESULT MODEL (KEEP AS IS)
////////////////////////////////////////////////////////////

class JobResult {
  final String fileName;
  final String status;
  final String candidateId;

  JobResult({
    required this.fileName,
    required this.status,
    required this.candidateId,
  });

  factory JobResult.fromJson(Map<String, dynamic> json) {
    return JobResult(
      fileName: json["fileName"] ?? "",
      status: json["status"] ?? "",
      candidateId: json["candidateId"] ?? "",
    );
  }
}
