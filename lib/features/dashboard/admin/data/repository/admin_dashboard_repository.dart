import 'package:dio/dio.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import '../../../../../core/network/api_client.dart';

class AdminDashboardRepository {
  final Dio _dio = ApiClient.instance;

  //////////////////////////////////////////////////////////////
  /// GET ADMIN DASHBOARD STATS
  //////////////////////////////////////////////////////////////

  Future<AdminDashboardModel> getDashboardStats() async {
    try {
      print("DEBUG: Calling GET /dashboard/admin");

      final response = await _dio.get("/dashboard/admin");

      print("DEBUG: Dashboard response: ${response.data}");

      return AdminDashboardModel.fromJson(response.data);
    } catch (e) {
      print("DEBUG: Dashboard error: $e");
      rethrow;
    }
  }
}
