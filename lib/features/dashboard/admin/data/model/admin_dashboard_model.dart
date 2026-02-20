class AdminDashboardModel {
  final int totalUsers;
  final int totalJobs;
  final int totalApplications;
  final int totalPartners;
  final int pendingPartners;
  final int approvedPartners;
  final int rejectedPartners;

  const AdminDashboardModel({
    required this.totalUsers,
    required this.totalJobs,
    required this.totalApplications,
    required this.totalPartners,
    required this.pendingPartners,
    required this.approvedPartners,
    required this.rejectedPartners,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return AdminDashboardModel(
      totalUsers: data['users']['total'] ?? 0,

      totalJobs: data['jobs']['total'] ?? 0,

      totalApplications: data['applications']['total'] ?? 0,

      totalPartners: data['partners']['total'] ?? 0,
      pendingPartners: data['partners']['pending'] ?? 0,
      approvedPartners: data['partners']['approved'] ?? 0,
      rejectedPartners: data['partners']['rejected'] ?? 0,
    );
  }
}
