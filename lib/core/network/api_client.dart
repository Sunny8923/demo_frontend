import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import 'api_endpoints.dart';

class ApiClient {
  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {"Content-Type": "application/json"},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await TokenStorage.getToken();

              if (token != null && token.isNotEmpty) {
                options.headers["Authorization"] = "Bearer $token";
              } else {
                options.headers.remove("Authorization");
              }

              handler.next(options);
            },
          ),
        );

  static Dio get instance => _dio;
}
