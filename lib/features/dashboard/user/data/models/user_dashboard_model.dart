class UserDashboardModel {
  ////////////////////////////////////////////////////////
  /// Stats
  ////////////////////////////////////////////////////////

  final int totalApplications;
  final int activeApplications;
  final int hiredApplications;
  final int rejectedApplications;

  ////////////////////////////////////////////////////////
  /// Constructor
  ////////////////////////////////////////////////////////

  const UserDashboardModel({
    required this.totalApplications,
    required this.activeApplications,
    required this.hiredApplications,
    required this.rejectedApplications,
  });

  ////////////////////////////////////////////////////////
  /// Factory
  ////////////////////////////////////////////////////////

  factory UserDashboardModel.fromJson(Map<String, dynamic> json) {
    return UserDashboardModel(
      totalApplications: json['totalApplications'] ?? 0,
      activeApplications: json['activeApplications'] ?? 0,
      hiredApplications: json['hiredApplications'] ?? 0,
      rejectedApplications: json['rejectedApplications'] ?? 0,
    );
  }

  ////////////////////////////////////////////////////////
  /// Empty state
  ////////////////////////////////////////////////////////

  factory UserDashboardModel.empty() {
    return const UserDashboardModel(
      totalApplications: 0,
      activeApplications: 0,
      hiredApplications: 0,
      rejectedApplications: 0,
    );
  }
}
