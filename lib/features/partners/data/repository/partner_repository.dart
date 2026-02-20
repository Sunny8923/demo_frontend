import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_endpoints.dart';

import '../../../../core/network/api_client.dart';
import '../models/partner_model.dart';

class PartnerRepository {
  final Dio _dio = ApiClient.instance;

  Future<void> requestPartnerAccess({
    required String businessName,
    required String phone,
  }) async {
    await _dio.post(
      "/partners/request",
      data: {"businessName": businessName, "phone": phone},
    );
  }

  Future<List<PartnerModel>> getPendingPartners() async {
    print("DEBUG: Repository → Calling ${ApiEndpoints.partnerPending}");

    final response = await _dio.get(ApiEndpoints.partnerPending);

    print("DEBUG: Repository → Response: ${response.data}");

    final List list = response.data['requests'];

    return list.map((e) => PartnerModel.fromJson(e)).toList();
  }

  Future<void> approvePartner(String partnerId) async {
    final url = ApiEndpoints.approvePartner(partnerId);

    print("DEBUG: Repository → PATCH $url");

    final response = await _dio.patch(url);

    print("DEBUG: Repository → approve response: ${response.data}");
  }

  Future<PartnerModel> getMyPartnerProfile() async {
    try {
      print("DEBUG: Calling GET /partner/me");

      final response = await _dio.get("/partner/me");

      print("DEBUG: Status code: ${response.statusCode}");
      print("DEBUG: Response data: ${response.data}");

      final partnerJson = response.data['partner'];

      return PartnerModel.fromJson(partnerJson);
    } catch (e) {
      print("DEBUG: Partner profile error: $e");
      rethrow;
    }
  }
}
