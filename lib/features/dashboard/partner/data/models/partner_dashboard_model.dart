class PartnerDashboardModel {
  ////////////////////////////////////////////////////////////
  /// Core stats
  ////////////////////////////////////////////////////////////

  final int candidatesSubmitted;
  final int applicationsSubmitted;
  final int activeApplications;
  final int hiredApplications;
  final int rejectedApplications;

  ////////////////////////////////////////////////////////////
  /// Constructor
  ////////////////////////////////////////////////////////////

  const PartnerDashboardModel({
    required this.candidatesSubmitted,
    required this.applicationsSubmitted,
    required this.activeApplications,
    required this.hiredApplications,
    required this.rejectedApplications,
  });

  ////////////////////////////////////////////////////////////
  /// Factory
  ////////////////////////////////////////////////////////////

  factory PartnerDashboardModel.fromJson(Map<String, dynamic> json) {
    return PartnerDashboardModel(
      candidatesSubmitted: json['candidatesSubmitted'] ?? 0,
      applicationsSubmitted: json['applicationsSubmitted'] ?? 0,
      activeApplications: json['activeApplications'] ?? 0,
      hiredApplications: json['hiredApplications'] ?? 0,
      rejectedApplications: json['rejectedApplications'] ?? 0,
    );
  }
}
