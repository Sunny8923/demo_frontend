import 'package:dio/dio.dart';
import '../../../../../../core/network/api_client.dart';

class CandidateRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<dynamic>> getCandidates() async {
    final response = await _dio.get("/admin/candidates");

    return response.data["candidates"] ?? [];
  }
}
