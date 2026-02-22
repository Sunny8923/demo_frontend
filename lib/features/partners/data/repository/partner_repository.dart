import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_endpoints.dart';

import '../../../../core/network/api_client.dart';
import '../models/partner_model.dart';

class PartnerRepository {
  final Dio _dio = ApiClient.instance;

  ////////////////////////////////////////////////////////////
  /// REQUEST PARTNER ACCESS
  ////////////////////////////////////////////////////////////
  Future<void> requestPartnerAccess({
    required String businessName,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.partnerSignup,
        data: {"organisationName": businessName, "contactNumber": phone},
      );

      final data = response.data;

      if (data == null || data["success"] != true) {
        throw Exception(data?["message"] ?? "Failed to request partner access");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ?? e.message ?? "Partner request failed",
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// GET PENDING PARTNERS
  ////////////////////////////////////////////////////////////
  Future<List<PartnerModel>> getPendingPartners() async {
    try {
      print("DEBUG: Calling ${ApiEndpoints.partnerPending}");

      final response = await _dio.get(ApiEndpoints.partnerPending);

      final responseData = response.data;

      print("DEBUG: RAW RESPONSE TYPE: ${responseData.runtimeType}");
      print("DEBUG: RAW RESPONSE: $responseData");

      if (responseData == null) {
        throw Exception("Empty server response");
      }

      if (responseData["success"] != true) {
        throw Exception(responseData["message"] ?? "Failed to load partners");
      }

      ////////////////////////////////////////////////////////////
      /// SAFE extraction
      ////////////////////////////////////////////////////////////

      dynamic rawList = responseData["data"];

      List list;

      if (rawList is List) {
        list = rawList;
      } else if (rawList is Map) {
        /// sometimes backend sends object instead of list
        list = rawList.values.toList();
      } else {
        throw Exception("Unexpected partner list format");
      }

      ////////////////////////////////////////////////////////////
      /// SAFE parsing
      ////////////////////////////////////////////////////////////

      return list.map((e) {
        if (e is Map<String, dynamic>) {
          return PartnerModel.fromJson(e);
        } else {
          throw Exception("Invalid partner object format");
        }
      }).toList();
    } on DioException catch (e) {
      print("DEBUG: DIO ERROR: ${e.response?.data}");

      throw Exception(
        e.response?.data?["message"] ?? e.message ?? "Failed to load partners",
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// APPROVE PARTNER
  ////////////////////////////////////////////////////////////
  Future<void> approvePartner(String partnerId) async {
    try {
      final url = ApiEndpoints.approvePartner(partnerId);

      print("DEBUG: Approving partner → $url");

      final response = await _dio.patch(url);

      final data = response.data;

      if (data == null || data["success"] != true) {
        throw Exception(data?["message"] ?? "Failed to approve partner");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ?? e.message ?? "Partner approval failed",
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// REJECT PARTNER
  ////////////////////////////////////////////////////////////
  Future<void> rejectPartner(String partnerId) async {
    try {
      final url = ApiEndpoints.rejectPartner(partnerId);

      final response = await _dio.patch(url);

      final data = response.data;

      if (data == null || data["success"] != true) {
        throw Exception(data?["message"] ?? "Failed to reject partner");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ?? e.message ?? "Partner reject failed",
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// GET MY PROFILE
  ////////////////////////////////////////////////////////////
  Future<PartnerModel> getMyPartnerProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.partnerMe);

      final data = response.data;

      if (data == null || data["data"] == null) {
        throw Exception("Invalid partner profile response");
      }

      return PartnerModel.fromJson(data["data"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ??
            e.message ??
            "Failed to load partner profile",
      );
    }
  }
}
