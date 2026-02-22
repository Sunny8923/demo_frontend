class UserDashboardModel {
  ////////////////////////////////////////////////////////
  /// Stats
  ////////////////////////////////////////////////////////

  final int totalApplications;
  final int activeApplications;
  final int hired;
  final int rejected;

  ////////////////////////////////////////////////////////
  /// Range
  ////////////////////////////////////////////////////////

  final String range;

  ////////////////////////////////////////////////////////
  /// Constructor
  ////////////////////////////////////////////////////////

  const UserDashboardModel({
    required this.totalApplications,
    required this.activeApplications,
    required this.hired,
    required this.rejected,
    required this.range,
  });

  ////////////////////////////////////////////////////////
  /// Factory
  ////////////////////////////////////////////////////////

  factory UserDashboardModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] ?? {};

    return UserDashboardModel(
      totalApplications: summary['totalApplications'] ?? 0,
      activeApplications: summary['activeApplications'] ?? 0,
      hired: summary['hired'] ?? 0,
      rejected: summary['rejected'] ?? 0,
      range: json['range'] ?? "7d",
    );
  }

  ////////////////////////////////////////////////////////
  /// Empty
  ////////////////////////////////////////////////////////

  factory UserDashboardModel.empty() {
    return const UserDashboardModel(
      totalApplications: 0,
      activeApplications: 0,
      hired: 0,
      rejected: 0,
      range: "7d",
    );
  }
}
