class PartnerDashboardModel {
  ////////////////////////////////////////////////////////////
  /// Core stats
  ////////////////////////////////////////////////////////////

  final int totalCandidates;
  final int totalApplications;
  final int activeApplications;
  final int hired;
  final int rejected;

  ////////////////////////////////////////////////////////////
  /// Range (needed for header chip)
  ////////////////////////////////////////////////////////////

  final String range;

  ////////////////////////////////////////////////////////////
  /// Constructor
  ////////////////////////////////////////////////////////////

  const PartnerDashboardModel({
    required this.totalCandidates,
    required this.totalApplications,
    required this.activeApplications,
    required this.hired,
    required this.rejected,
    required this.range,
  });

  ////////////////////////////////////////////////////////////
  /// Factory
  ////////////////////////////////////////////////////////////

  factory PartnerDashboardModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] ?? {};

    return PartnerDashboardModel(
      totalCandidates: summary['totalCandidates'] ?? 0,
      totalApplications: summary['totalApplications'] ?? 0,
      activeApplications: summary['activeApplications'] ?? 0,
      hired: summary['hired'] ?? 0,
      rejected: summary['rejected'] ?? 0,
      range: json['range'] ?? "7d",
    );
  }
}
