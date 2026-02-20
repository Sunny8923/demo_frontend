import 'package:dio/dio.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/auth_response_model.dart';

class AuthRepository {
  final Dio _dio = ApiClient.instance;

  Future<AuthResponseModel> login(String email, String password) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {"email": email, "password": password},
    );

    final auth = AuthResponseModel.fromJson(response.data);

    await TokenStorage.saveToken(auth.token);

    return auth;
  }

  Future<void> signup(String name, String email, String password) async {
    final response = await _dio.post(
      ApiEndpoints.signup,
      data: {"name": name, "email": email, "password": password},
    );

    print("Signup success: ${response.data}");
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(ApiEndpoints.me);

    final userJson = response.data['user'];

    return UserModel.fromJson(userJson);
  }

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
    await _dio.post(
      ApiEndpoints.partnerSignup,
      data: {
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
      },
    );
  }
}
