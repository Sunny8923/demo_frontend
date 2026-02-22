import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../models/partner_dashboard_model.dart';

class PartnerDashboardRepository {
  final Dio _dio = ApiClient.instance;

  Future<PartnerDashboardModel> getDashboard() async {
    try {
      print("DEBUG: Repository → GET /partner/dashboard");

      final response = await _dio.get("/partner/dashboard");

      print("DEBUG: Repository → Response: ${response.data}");

      final data = response.data['data'];

      return PartnerDashboardModel.fromJson(data);
    } catch (e) {
      print("DEBUG: Partner dashboard error: $e");
      rethrow;
    }
  }
}
