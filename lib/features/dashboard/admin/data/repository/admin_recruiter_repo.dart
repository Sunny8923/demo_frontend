import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';

class AdminRecruiterRepository {
  final Dio _dio = ApiClient.instance;

  //////////////////////////////////////////////////////////////
  /// CREATE RECRUITER
  //////////////////////////////////////////////////////////////
  Future<void> createRecruiter({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print("DEBUG: Creating recruiter → $email");

      final response = await _dio.post(
        "/admin/recruiters",
        data: {"name": name, "email": email, "password": password},
      );

      print("DEBUG: Create recruiter response → ${response.data}");

      if (response.data["success"] != true) {
        throw Exception(
          response.data["message"] ?? "Failed to create recruiter",
        );
      }
    } on DioException catch (e) {
      print("ERROR: Create recruiter DioException → ${e.response?.data}");

      throw Exception(
        e.response?.data?["message"] ??
            e.message ??
            "Failed to create recruiter",
      );
    } catch (e) {
      print("ERROR: Create recruiter → $e");
      rethrow;
    }
  }
}
