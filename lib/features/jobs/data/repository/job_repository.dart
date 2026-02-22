import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/job_model.dart';

class JobRepository {
  final Dio _dio = ApiClient.instance;

  ////////////////////////////////////////////////////////////
  /// CREATE SINGLE JOB
  ////////////////////////////////////////////////////////////
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
    try {
      ////////////////////////////////////////////////////////////
      /// FIX: Convert status to Prisma enum format (OPEN, CLOSED)
      ////////////////////////////////////////////////////////////
      final formattedStatus = status?.toUpperCase();

      final response = await _dio.post(
        ApiEndpoints.jobs,
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
          "status": formattedStatus,
          "requestDate": requestDate?.toIso8601String(),
          "closureDate": closureDate?.toIso8601String(),
        },
      );

      ////////////////////////////////////////////////////////////
      /// SAFE RESPONSE PARSE (NEW BACKEND FORMAT)
      ///
      /// backend returns:
      /// {
      ///   success: true,
      ///   message: "...",
      ///   data: {...job}
      /// }
      ////////////////////////////////////////////////////////////

      final responseData = response.data;

      if (responseData == null) {
        throw Exception("Empty server response");
      }

      if (responseData["success"] != true) {
        throw Exception(responseData["message"] ?? "Failed to create job");
      }

      final jobJson = responseData["data"];

      if (jobJson == null || jobJson is! Map<String, dynamic>) {
        throw Exception("Invalid job data received from server");
      }

      return JobModel.fromJson(jobJson);
    } on DioException catch (e) {
      final message =
          e.response?.data?["message"] ??
          e.message ??
          "Network error while creating job";

      throw Exception(message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  ////////////////////////////////////////////////////////////
  /// UPLOAD CSV
  ////////////////////////////////////////////////////////////
  Future<Map<String, dynamic>> uploadCSV(File file) async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path),
      });

      final response = await _dio.post(
        ApiEndpoints.uploadJobsCsv,
        data: formData,
      );

      final responseData = response.data;

      if (responseData == null) {
        throw Exception("Empty server response");
      }

      return responseData;
    } on DioException catch (e) {
      final message =
          e.response?.data?["message"] ?? e.message ?? "CSV upload failed";

      throw Exception(message);
    }
  }

  ////////////////////////////////////////////////////////////
  /// GET ALL JOBS
  ////////////////////////////////////////////////////////////
  Future<List<JobModel>> getAllJobs() async {
    try {
      final response = await _dio.get(ApiEndpoints.jobs);

      ////////////////////////////////////////////////////////////
      /// backend returns:
      /// {
      ///   success: true,
      ///   count: number,
      ///   data: [...]
      /// }
      ////////////////////////////////////////////////////////////

      final responseData = response.data;

      if (responseData == null) {
        throw Exception("Empty server response");
      }

      if (responseData["success"] != true) {
        throw Exception(responseData["message"] ?? "Failed to fetch jobs");
      }

      final jobsJson = responseData["data"];

      if (jobsJson == null || jobsJson is! List) {
        throw Exception("Invalid jobs data received");
      }

      return jobsJson
          .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message =
          e.response?.data?["message"] ??
          e.message ??
          "Network error while fetching jobs";

      throw Exception(message);
    }
  }
}
