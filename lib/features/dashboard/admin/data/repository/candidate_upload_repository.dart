import 'package:dio/dio.dart';
import '../../../../../../core/network/api_client.dart';

class CandidateUploadRepository {
  final Dio _dio = ApiClient.instance;

  ////////////////////////////////////////////////////////////
  /// UPLOAD RESUMES
  ////////////////////////////////////////////////////////////

  Future<String> uploadResumes(List<dynamic> files) async {
    try {
      print("========================================");
      print("UPLOAD RESUMES API CALLED");

      final formData = FormData();

      for (var file in files) {
        formData.files.add(
          MapEntry(
            "resumes",
            MultipartFile.fromBytes(
              await file.arrayBuffer().then((value) => value.asUint8List()),
              filename: file.name,
            ),
          ),
        );
      }

      final response = await _dio.post(
        "/admin/resumes/upload",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      print("UPLOAD RESPONSE: ${response.data}");

      return response.data["jobId"];
    } on DioException catch (e) {
      print("UPLOAD FAILED: ${e.response?.data}");
      rethrow;
    }
  }
}
