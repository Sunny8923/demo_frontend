import 'package:dio/dio.dart';
import '../../../../../../core/network/api_client.dart';

class JobStatusRepository {
  final Dio _dio = ApiClient.instance;

  Future<Map<String, dynamic>> getStatus(String jobId) async {
    try {
      final response = await _dio.get("/admin/resumes/job/$jobId");

      return response.data;
    } on DioException catch (e) {
      print("STATUS ERROR: ${e.response?.data}");
      rethrow;
    }
  }
}
