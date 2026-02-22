import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/application_model.dart';

class ApplicationRepository {
  final Dio _dio = ApiClient.instance;

  ////////////////////////////////////////////////////////////
  /// APPLY TO JOB
  ////////////////////////////////////////////////////////////

  Future<void> applyToJob({
    required String jobId,
    required String name,
    required String email,
    required String phone,

    String? currentLocation,
    String? totalExperience,
    String? currentCompany,
    String? currentDesignation,
    String? expectedSalary,
    String? noticePeriodDays,
    String? skills,
    String? highestQualification,
  }) async {
    try {
      final candidate = {
        "name": name,
        "email": email,
        "phone": phone,

        if (currentLocation?.isNotEmpty == true)
          "currentLocation": currentLocation,

        if (totalExperience?.isNotEmpty == true)
          "totalExperience": double.tryParse(totalExperience!),

        if (currentCompany?.isNotEmpty == true)
          "currentCompany": currentCompany,

        if (currentDesignation?.isNotEmpty == true)
          "currentDesignation": currentDesignation,

        if (expectedSalary?.isNotEmpty == true)
          "expectedSalary": double.tryParse(expectedSalary!),

        if (noticePeriodDays?.isNotEmpty == true)
          "noticePeriodDays": int.tryParse(noticePeriodDays!),

        if (skills?.isNotEmpty == true) "skills": skills,

        if (highestQualification?.isNotEmpty == true)
          "highestQualification": highestQualification,
      };

      final body = {"jobId": jobId, "candidate": candidate};

      final response = await _dio.post("/applications/apply", data: body);

      final data = response.data;

      if (data == null || data["success"] != true) {
        throw Exception(data?["message"] ?? "Application failed");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ?? e.message ?? "Application failed",
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// GET MY APPLICATIONS
  ////////////////////////////////////////////////////////////

  Future<List<ApplicationModel>> getMyApplications() async {
    try {
      final response = await _dio.get("/applications/my");

      final data = response.data;

      if (data == null || data["success"] != true) {
        throw Exception("Failed to fetch applications");
      }

      final list = data["data"];

      if (list == null || list is! List) {
        return [];
      }

      return list.map((e) => ApplicationModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ??
            e.message ??
            "Failed to fetch applications",
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// GET ALL APPLICATIONS (ADMIN)
  ////////////////////////////////////////////////////////////

  Future<List<ApplicationModel>> getAllApplications() async {
    try {
      final response = await _dio.get("/applications");

      final data = response.data;

      print("DEBUG APPLICATION RESPONSE: $data");

      if (data == null) {
        throw Exception("Empty server response");
      }

      if (data["success"] != true) {
        throw Exception(data["message"] ?? "Failed to fetch applications");
      }

      final list = data["data"];

      if (list == null || list is! List) {
        return [];
      }

      return list.map((e) => ApplicationModel.fromJson(e)).toList();
    } on DioException catch (e) {
      print("DEBUG APPLICATION ERROR: ${e.response?.data}");

      throw Exception(
        e.response?.data?["message"] ??
            e.message ??
            "Failed to fetch applications",
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// UPDATE PIPELINE STAGE
  ////////////////////////////////////////////////////////////

  Future<void> updateApplicationStage({
    required String applicationId,
    required String pipelineStage,
  }) async {
    try {
      final response = await _dio.patch(
        "/applications/$applicationId/status",
        data: {"pipelineStage": pipelineStage},
      );

      final data = response.data;

      if (data == null || data["success"] != true) {
        throw Exception(data?["message"] ?? "Failed to update status");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ?? e.message ?? "Failed to update status",
      );
    }
  }
}
