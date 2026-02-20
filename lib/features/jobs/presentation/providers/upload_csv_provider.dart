import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/jobs/data/repository/job_repository.dart';

import 'create_job_provider.dart';

/// Model to hold CSV upload result
class CsvUploadResult {
  final bool success;

  final int totalRows;
  final int validRows;
  final int created;
  final int duplicates;
  final int skipped;
  final int failed;

  final List errors;

  CsvUploadResult({
    required this.success,
    required this.totalRows,
    required this.validRows,
    required this.created,
    required this.duplicates,
    required this.skipped,
    required this.failed,
    required this.errors,
  });

  factory CsvUploadResult.fromJson(Map<String, dynamic> json) {
    final summary = json["summary"] ?? {};

    return CsvUploadResult(
      success: json["message"] == "CSV uploaded successfully",

      totalRows: summary["totalRows"] ?? 0,
      validRows: summary["validRows"] ?? 0,
      created: summary["created"] ?? 0,
      duplicates: summary["duplicates"] ?? 0,
      skipped: summary["skipped"] ?? 0,
      failed: summary["failed"] ?? 0,

      errors: json["errors"] ?? [],
    );
  }
}

final uploadCsvProvider =
    AsyncNotifierProvider<UploadCsvNotifier, CsvUploadResult?>(
      UploadCsvNotifier.new,
    );

class UploadCsvNotifier extends AsyncNotifier<CsvUploadResult?> {
  late final JobRepository _repository;

  @override
  Future<CsvUploadResult?> build() async {
    _repository = ref.read(jobRepositoryProvider);

    return null;
  }

  Future<CsvUploadResult?> upload(File file) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response = await _repository.uploadCSV(file);

      final result = CsvUploadResult.fromJson(response);

      return result;
    });

    return state.value;
  }

  void reset() {
    state = const AsyncData(null);
  }
}
