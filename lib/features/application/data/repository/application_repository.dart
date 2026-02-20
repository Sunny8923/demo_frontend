import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/application_model.dart';

class ApplicationRepository {
  final Dio _dio = ApiClient.instance;

  ////////////////////////////////////////////////////////////
  /// APPLY TO JOB (FIXED — sends candidate object)
  ////////////////////////////////////////////////////////////

  Future<void> applyToJob({
    required String jobId,

    /// required
    required String name,
    required String email,
    required String phone,

    /// optional extended profile
    String? currentLocation,
    String? totalExperience,
    String? currentCompany,
    String? currentDesignation,
    String? expectedSalary,
    String? noticePeriodDays,
    String? skills,
    String? highestQualification,
  }) async {
    ////////////////////////////////////////////////////////////
    /// Build candidate object
    ////////////////////////////////////////////////////////////

    final candidate = {
      "name": name,
      "email": email,
      "phone": phone,

      if (currentLocation != null && currentLocation.isNotEmpty)
        "currentLocation": currentLocation,

      if (totalExperience != null && totalExperience.isNotEmpty)
        "totalExperience": double.tryParse(totalExperience),

      if (currentCompany != null && currentCompany.isNotEmpty)
        "currentCompany": currentCompany,

      if (currentDesignation != null && currentDesignation.isNotEmpty)
        "currentDesignation": currentDesignation,

      if (expectedSalary != null && expectedSalary.isNotEmpty)
        "expectedSalary": double.tryParse(expectedSalary),

      if (noticePeriodDays != null && noticePeriodDays.isNotEmpty)
        "noticePeriodDays": int.tryParse(noticePeriodDays),

      if (skills != null && skills.isNotEmpty) "skills": skills,

      if (highestQualification != null && highestQualification.isNotEmpty)
        "highestQualification": highestQualification,
    };

    ////////////////////////////////////////////////////////////
    /// Final request body (IMPORTANT FIX)
    ////////////////////////////////////////////////////////////

    final data = {"jobId": jobId, "candidate": candidate};

    ////////////////////////////////////////////////////////////
    /// API call
    ////////////////////////////////////////////////////////////

    await _dio.post("/applications/apply", data: data);
  }

  ////////////////////////////////////////////////////////////
  /// GET MY APPLICATIONS
  ////////////////////////////////////////////////////////////

  Future<List<ApplicationModel>> getMyApplications() async {
    final response = await _dio.get("/applications/my");

    final List list = response.data['applications'];

    return list.map((e) => ApplicationModel.fromJson(e)).toList();
  }

  ////////////////////////////////////////////////////////////
  /// GET ALL APPLICATIONS (ADMIN)
  ////////////////////////////////////////////////////////////

  Future<List<ApplicationModel>> getAllApplications() async {
    final response = await _dio.get("/applications");

    final List list = response.data['applications'];

    return list.map((e) => ApplicationModel.fromJson(e)).toList();
  }

  ////////////////////////////////////////////////////////////
  /// UPDATE PIPELINE STAGE
  ////////////////////////////////////////////////////////////

  Future<void> updateApplicationStage({
    required String applicationId,
    required String pipelineStage,
  }) async {
    await _dio.patch(
      "/applications/$applicationId/status",
      data: {"pipelineStage": pipelineStage},
    );
  }
}
