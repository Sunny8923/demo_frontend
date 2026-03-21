import 'package:dio/dio.dart';
import '../../../../../../core/network/api_client.dart';
import '../model/candidate_model.dart';

////////////////////////////////////////////////////////////
/// RESPONSE MODEL (FOR PAGINATION)
////////////////////////////////////////////////////////////

class CandidateResponse {
  final List<Candidate> candidates;
  final int total;
  final int page;
  final int totalPages;
  final int limit;

  CandidateResponse({
    required this.candidates,
    required this.total,
    required this.page,
    required this.totalPages,
    required this.limit,
  });
}

////////////////////////////////////////////////////////////
/// REPOSITORY
////////////////////////////////////////////////////////////

class CandidateRepository {
  final Dio _dio = ApiClient.instance;

  ////////////////////////////////////////////////////////////
  /// GET CANDIDATES (WITH FILTERS + PAGINATION)
  ////////////////////////////////////////////////////////////

  Future<CandidateResponse> getCandidates({
    String? search,
    double? minExperience,
    double? maxExperience,
    String? location,
    String? skills,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      "/admin/candidates",
      queryParameters: {
        if (search != null && search.isNotEmpty) "search": search,
        if (minExperience != null) "minExperience": minExperience,
        if (maxExperience != null) "maxExperience": maxExperience,
        if (location != null && location.isNotEmpty) "location": location,
        if (skills != null && skills.isNotEmpty) "skills": skills,
        "page": page,
        "limit": limit,
      },
    );

    final data = response.data;

    return CandidateResponse(
      candidates: (data["candidates"] as List)
          .map((e) => Candidate.fromJson(e))
          .toList(),
      total: data["total"] ?? 0,
      page: data["page"] ?? 1,
      totalPages: data["totalPages"] ?? 1,
      limit: data["limit"] ?? limit,
    );
  }

  ////////////////////////////////////////////////////////////
  /// GET SINGLE CANDIDATE
  ////////////////////////////////////////////////////////////

  Future<Candidate> getCandidateById(String id) async {
    final response = await _dio.get("/admin/candidates/$id");

    return Candidate.fromJson(response.data["candidate"]);
  }
}
