import 'package:dio/dio.dart';
import 'package:frontend/features/dashboard/recruiter/data/model/recruiter_dashboard_model.dart';
import '../../../../../core/network/api_client.dart';

class RecruiterDashboardRepository {
  final Dio _dio = ApiClient.instance;

  Future<RecruiterDashboardModel> getDashboard() async {
    print("DEBUG: Fetching recruiter dashboard");

    final response = await _dio.get("/recruiter/dashboard");

    print("DEBUG: Recruiter dashboard response: ${response.data}");

    final data = response.data['data'];

    return RecruiterDashboardModel.fromJson(data);
  }
}
