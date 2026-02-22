class RecruiterDashboardModel {
  ////////////////////////////////////////////////////////////
  /// Summary
  ////////////////////////////////////////////////////////////

  final int totalCandidatesAdded;
  final int activeJobsWorkedOn;
  final int totalApplications;
  final int active;
  final int hired;
  final int rejected;

  ////////////////////////////////////////////////////////////
  /// Constructor
  ////////////////////////////////////////////////////////////

  const RecruiterDashboardModel({
    required this.totalCandidatesAdded,
    required this.activeJobsWorkedOn,
    required this.totalApplications,
    required this.active,
    required this.hired,
    required this.rejected,
  });

  ////////////////////////////////////////////////////////////
  /// Factory
  ////////////////////////////////////////////////////////////

  factory RecruiterDashboardModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] ?? {};

    return RecruiterDashboardModel(
      totalCandidatesAdded: summary['totalCandidatesAdded'] ?? 0,
      activeJobsWorkedOn: summary['activeJobsWorkedOn'] ?? 0,
      totalApplications: summary['totalApplications'] ?? 0,
      active: summary['active'] ?? 0,
      hired: summary['hired'] ?? 0,
      rejected: summary['rejected'] ?? 0,
    );
  }

  ////////////////////////////////////////////////////////////
  /// Empty
  ////////////////////////////////////////////////////////////

  factory RecruiterDashboardModel.empty() {
    return const RecruiterDashboardModel(
      totalCandidatesAdded: 0,
      activeJobsWorkedOn: 0,
      totalApplications: 0,
      active: 0,
      hired: 0,
      rejected: 0,
    );
  }
}
