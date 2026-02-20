import 'package:dio/dio.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/auth_response_model.dart';

class AuthRepository {
  final Dio _dio = ApiClient.instance;

  ////////////////////////////////////////////////////////////
  // LOGIN WITH FULL DEBUG LOGS
  ////////////////////////////////////////////////////////////

  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final requestBody = {"email": email.trim(), "password": password.trim()};

      print("========================================");
      print("LOGIN API CALLED");
      print("URL: ${_dio.options.baseUrl}${ApiEndpoints.login}");
      print("HEADERS: ${_dio.options.headers}");
      print("REQUEST BODY: $requestBody");
      print("========================================");

      final response = await _dio.post(ApiEndpoints.login, data: requestBody);

      print("========================================");
      print("LOGIN SUCCESS RESPONSE");
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");
      print("========================================");

      final auth = AuthResponseModel.fromJson(response.data);

      print("TOKEN RECEIVED: ${auth.token}");

      await TokenStorage.saveToken(auth.token);

      print("TOKEN SAVED SUCCESSFULLY");

      return auth;
    } on DioException catch (e) {
      print("========================================");
      print("LOGIN FAILED");
      print("ERROR MESSAGE: ${e.message}");
      print("STATUS CODE: ${e.response?.statusCode}");
      print("RESPONSE DATA: ${e.response?.data}");
      print("REQUEST DATA: ${e.requestOptions.data}");
      print("REQUEST HEADERS: ${e.requestOptions.headers}");
      print("REQUEST URL: ${e.requestOptions.uri}");
      print("========================================");

      rethrow;
    } catch (e) {
      print("========================================");
      print("UNKNOWN LOGIN ERROR: $e");
      print("========================================");
      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  // SIGNUP WITH DEBUG
  ////////////////////////////////////////////////////////////

  Future<void> signup(String name, String email, String password) async {
    try {
      final body = {
        "name": name.trim(),
        "email": email.trim(),
        "password": password.trim(),
      };

      print("========================================");
      print("SIGNUP API CALLED");
      print("URL: ${_dio.options.baseUrl}${ApiEndpoints.signup}");
      print("BODY: $body");
      print("========================================");

      final response = await _dio.post(ApiEndpoints.signup, data: body);

      print("SIGNUP SUCCESS: ${response.data}");
    } on DioException catch (e) {
      print("SIGNUP FAILED");
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  // GET CURRENT USER WITH DEBUG
  ////////////////////////////////////////////////////////////

  Future<UserModel> getCurrentUser() async {
    try {
      print("========================================");
      print("GET CURRENT USER API CALLED");
      print("URL: ${_dio.options.baseUrl}${ApiEndpoints.me}");
      print("HEADERS: ${_dio.options.headers}");
      print("========================================");

      final response = await _dio.get(ApiEndpoints.me);

      print("GET USER RESPONSE: ${response.data}");

      final userJson = response.data['data'];

      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      print("GET USER FAILED");
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  // PARTNER SIGNUP DEBUG
  ////////////////////////////////////////////////////////////

  Future<void> partnerSignup({
    required String name,
    required String email,
    required String password,
    required String organisationName,
    required String ownerName,
    required String establishmentDate,
    required String gstNumber,
    required String panNumber,
    required String address,
    required String contactNumber,
    required String officialEmail,
    required bool msmeRegistered,
  }) async {
    try {
      final body = {
        "name": name,
        "email": email,
        "password": password,
        "organisationName": organisationName,
        "ownerName": ownerName,
        "establishmentDate": establishmentDate,
        "gstNumber": gstNumber,
        "panNumber": panNumber,
        "address": address,
        "contactNumber": contactNumber,
        "officialEmail": officialEmail,
        "msmeRegistered": msmeRegistered,
      };

      print("========================================");
      print("PARTNER SIGNUP API CALLED");
      print("URL: ${_dio.options.baseUrl}${ApiEndpoints.partnerSignup}");
      print("BODY: $body");
      print("========================================");

      final response = await _dio.post(ApiEndpoints.partnerSignup, data: body);

      print("PARTNER SIGNUP SUCCESS: ${response.data}");
    } on DioException catch (e) {
      print("PARTNER SIGNUP FAILED");
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      rethrow;
    }
  }
}
