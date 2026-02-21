import 'package:dio/dio.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import '../../../../../core/network/api_client.dart';

class AdminDashboardRepository {
  final Dio _dio = ApiClient.instance;

  //////////////////////////////////////////////////////////////
  /// GET ADMIN DASHBOARD STATS
  //////////////////////////////////////////////////////////////
  Future<AdminDashboardData> getDashboardStats({String range = "7d"}) async {
    final response = await _dio.get(
      "/admin/dashboard",
      queryParameters: {"range": range},
    );

    return AdminDashboardData.fromJson(response.data);
  }
}
