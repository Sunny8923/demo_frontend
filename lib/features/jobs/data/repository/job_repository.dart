import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/job_model.dart';

class JobRepository {
  final Dio _dio = ApiClient.instance;

  /// CREATE SINGLE JOB
  Future<JobModel> createJob({
    required String title,
    required String companyName,
    required String location,

    String? jrCode,
    String? description,
    String? department,

    int? minExperience,
    int? maxExperience,

    int? salaryMin,
    int? salaryMax,

    int? openings,

    String? skills,
    String? education,

    String? status,

    DateTime? requestDate,
    DateTime? closureDate,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.jobs, // "/jobs"
      data: {
        "jrCode": jrCode,
        "title": title,
        "description": description,
        "companyName": companyName,
        "department": department,
        "location": location,
        "minExperience": minExperience,
        "maxExperience": maxExperience,
        "salaryMin": salaryMin,
        "salaryMax": salaryMax,
        "openings": openings,
        "skills": skills,
        "education": education,
        "status": status,
        "requestDate": requestDate?.toIso8601String(),
        "closureDate": closureDate?.toIso8601String(),
      },
    );

    final jobJson = response.data["job"];

    return JobModel.fromJson(jobJson);
  }

  /// UPLOAD CSV
  Future<Map<String, dynamic>> uploadCSV(File file) async {
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path),
    });

    final response = await _dio.post(
      ApiEndpoints.uploadJobsCsv, // "/jobs/upload-csv"
      data: formData,
    );

    return response.data;
  }

  /// GET ALL JOBS (future dashboard use)
  Future<List<JobModel>> getAllJobs() async {
    final response = await _dio.get(ApiEndpoints.jobs);

    final List jobsJson = response.data["jobs"];

    return jobsJson.map((e) => JobModel.fromJson(e)).toList();
  }
}
