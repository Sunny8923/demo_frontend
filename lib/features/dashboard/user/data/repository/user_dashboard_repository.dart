import 'package:dio/dio.dart';
import 'package:frontend/features/dashboard/user/data/models/user_dashboard_model.dart';
import '../../../../../../core/network/api_client.dart';

class UserDashboardRepository {
  final Dio _dio = ApiClient.instance;

  Future<UserDashboardModel> getDashboard() async {
    print("DEBUG: Fetching USER dashboard");

    final response = await _dio.get("/dashboard/user");

    print("DEBUG: USER dashboard response: ${response.data}");

    final data = response.data['data'];

    return UserDashboardModel.fromJson(data);
  }
}
