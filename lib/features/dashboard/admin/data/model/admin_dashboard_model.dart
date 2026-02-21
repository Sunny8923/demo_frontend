class AdminDashboardData {
  final String range;

  final DashboardSummary summary;
  final DashboardSummaryChange summaryChange;
  final DashboardPipeline pipeline;
  final DashboardTrends trends;
  final DashboardDistribution distribution;
  final DashboardLeaderboards leaderboards;
  final DashboardConversion conversion;

  const AdminDashboardData({
    required this.range,
    required this.summary,
    required this.summaryChange,
    required this.pipeline,
    required this.trends,
    required this.distribution,
    required this.leaderboards,
    required this.conversion,
  });

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return AdminDashboardData(
      range: data['range'] ?? "7d",

      summary: DashboardSummary.fromJson(data['summary'] ?? {}),
      summaryChange: DashboardSummaryChange.fromJson(
        data['summaryChange'] ?? {},
      ), // ✅ NEW

      pipeline: DashboardPipeline.fromJson(data['pipeline'] ?? {}),

      trends: DashboardTrends.fromJson(data['trends'] ?? {}),

      distribution: DashboardDistribution.fromJson(data['distribution'] ?? {}),

      leaderboards: DashboardLeaderboards.fromJson(data['leaderboards'] ?? {}),

      conversion: DashboardConversion.fromJson(data['conversion'] ?? {}),
    );
  }
}

class DashboardSummary {
  final int totalPartners;
  final int activePartners;
  final int pendingPartners;

  final int totalRecruiters; // ✅ NEW
  final int activeRecruiters; // ✅ NEW

  final int totalJobs;
  final int openJobs;
  final int closedJobs;

  final int totalApplications;
  final int activeApplications;

  final int hired;
  final int rejected;

  const DashboardSummary({
    required this.totalPartners,
    required this.activePartners,
    required this.pendingPartners,
    required this.totalRecruiters, // ✅ NEW
    required this.activeRecruiters, // ✅ NEW
    required this.totalJobs,
    required this.openJobs,
    required this.closedJobs,
    required this.totalApplications,
    required this.activeApplications,
    required this.hired,
    required this.rejected,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalPartners: json['totalPartners'] ?? 0,
      activePartners: json['activePartners'] ?? 0,
      pendingPartners: json['pendingPartners'] ?? 0,

      totalRecruiters: json['totalRecruiters'] ?? 0, // ✅ NEW
      activeRecruiters: json['activeRecruiters'] ?? 0, // ✅ NEW

      totalJobs: json['totalJobs'] ?? 0,
      openJobs: json['openJobs'] ?? 0,
      closedJobs: json['closedJobs'] ?? 0,
      totalApplications: json['totalApplications'] ?? 0,
      activeApplications: json['activeApplications'] ?? 0,
      hired: json['hired'] ?? 0,
      rejected: json['rejected'] ?? 0,
    );
  }
}

class DashboardPipeline {
  final Map<String, int> stages;

  const DashboardPipeline({required this.stages});

  factory DashboardPipeline.fromJson(Map<String, dynamic> json) {
    final Map<String, int> parsed = {};

    json.forEach((key, value) {
      parsed[key] = value ?? 0;
    });

    return DashboardPipeline(stages: parsed);
  }
}

class DashboardSummaryChange {
  final double totalJobs;
  final double totalApplications;
  final double totalPartners;
  final double totalRecruiters;
  final double hired;

  const DashboardSummaryChange({
    required this.totalJobs,
    required this.totalApplications,
    required this.totalPartners,
    required this.totalRecruiters,
    required this.hired,
  });

  factory DashboardSummaryChange.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryChange(
      totalJobs: (json['totalJobs'] ?? 0).toDouble(),
      totalApplications: (json['totalApplications'] ?? 0).toDouble(),
      totalPartners: (json['totalPartners'] ?? 0).toDouble(),
      totalRecruiters: (json['totalRecruiters'] ?? 0).toDouble(),
      hired: (json['hired'] ?? 0).toDouble(),
    );
  }
}

class DashboardTrends {
  final List<TrendPoint> applications;
  final List<TrendPoint> hires;
  final List<TrendPoint> jobsCreated;

  const DashboardTrends({
    required this.applications,
    required this.hires,
    required this.jobsCreated,
  });

  factory DashboardTrends.fromJson(Map<String, dynamic> json) {
    List<TrendPoint> parseList(List? list) {
      if (list == null) return [];

      return list.map((e) => TrendPoint.fromJson(e)).toList();
    }

    return DashboardTrends(
      applications: parseList(json['applications']),
      hires: parseList(json['hires']),
      jobsCreated: parseList(json['jobsCreated']),
    );
  }
}

class TrendPoint {
  final String date;
  final int count;

  const TrendPoint({required this.date, required this.count});

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(date: json['date'] ?? "", count: json['count'] ?? 0);
  }
}

class DashboardDistribution {
  final Map<String, int> applicationsBySource;
  final List<DepartmentDistribution> applicationsByDepartment;
  final List<JobDistribution> applicationsByJob;

  const DashboardDistribution({
    required this.applicationsBySource,
    required this.applicationsByDepartment,
    required this.applicationsByJob,
  });

  factory DashboardDistribution.fromJson(Map<String, dynamic> json) {
    return DashboardDistribution(
      applicationsBySource: Map<String, int>.from(
        json['applicationsBySource'] ?? {},
      ),

      applicationsByDepartment:
          (json['applicationsByDepartment'] as List? ?? [])
              .map((e) => DepartmentDistribution.fromJson(e))
              .toList(),

      applicationsByJob: (json['applicationsByJob'] as List? ?? [])
          .map((e) => JobDistribution.fromJson(e))
          .toList(),
    );
  }
}

class DepartmentDistribution {
  final String department;
  final int applications;

  const DepartmentDistribution({
    required this.department,
    required this.applications,
  });

  factory DepartmentDistribution.fromJson(Map<String, dynamic> json) {
    return DepartmentDistribution(
      department: json['department'] ?? "",
      applications: json['applications'] ?? 0,
    );
  }
}

class JobDistribution {
  final String jobId;
  final String jobTitle;
  final int applications;

  const JobDistribution({
    required this.jobId,
    required this.jobTitle,
    required this.applications,
  });

  factory JobDistribution.fromJson(Map<String, dynamic> json) {
    return JobDistribution(
      jobId: json['jobId'] ?? "",
      jobTitle: json['jobTitle'] ?? "",
      applications: json['applications'] ?? 0,
    );
  }
}

class DashboardLeaderboards {
  final List<TopPartner> topPartners;
  final List<TopRecruiter> topRecruiters;
  final List<TopJob> topJobs;

  const DashboardLeaderboards({
    required this.topPartners,
    required this.topRecruiters,
    required this.topJobs,
  });

  factory DashboardLeaderboards.fromJson(Map<String, dynamic> json) {
    return DashboardLeaderboards(
      topPartners: (json['topPartners'] as List? ?? [])
          .map((e) => TopPartner.fromJson(e))
          .toList(),

      topRecruiters: (json['topRecruiters'] as List? ?? [])
          .map((e) => TopRecruiter.fromJson(e))
          .toList(),

      topJobs: (json['topJobs'] as List? ?? [])
          .map((e) => TopJob.fromJson(e))
          .toList(),
    );
  }
}

class TopPartner {
  final String partnerId;
  final String partnerName;
  final int applications;

  const TopPartner({
    required this.partnerId,
    required this.partnerName,
    required this.applications,
  });

  factory TopPartner.fromJson(Map<String, dynamic> json) {
    return TopPartner(
      partnerId: json['partnerId'] ?? "",
      partnerName: json['partnerName'] ?? "",
      applications: json['applications'] ?? 0,
    );
  }
}

class TopRecruiter {
  final String userId;
  final String userName;
  final int applications;

  const TopRecruiter({
    required this.userId,
    required this.userName,
    required this.applications,
  });

  factory TopRecruiter.fromJson(Map<String, dynamic> json) {
    return TopRecruiter(
      userId: json['userId'] ?? "",
      userName: json['userName'] ?? "",
      applications: json['applications'] ?? 0,
    );
  }
}

class TopJob {
  final String jobId;
  final String jobTitle;
  final int applications;

  const TopJob({
    required this.jobId,
    required this.jobTitle,
    required this.applications,
  });

  factory TopJob.fromJson(Map<String, dynamic> json) {
    return TopJob(
      jobId: json['jobId'] ?? "",
      jobTitle: json['jobTitle'] ?? "",
      applications: json['applications'] ?? 0,
    );
  }
}

class DashboardConversion {
  final double applicationToHireRate;
  final double screeningToInterviewRate;
  final double interviewToHireRate;

  const DashboardConversion({
    required this.applicationToHireRate,
    required this.screeningToInterviewRate,
    required this.interviewToHireRate,
  });

  factory DashboardConversion.fromJson(Map<String, dynamic> json) {
    return DashboardConversion(
      applicationToHireRate: (json['applicationToHireRate'] ?? 0).toDouble(),

      screeningToInterviewRate: (json['screeningToInterviewRate'] ?? 0)
          .toDouble(),

      interviewToHireRate: (json['interviewToHireRate'] ?? 0).toDouble(),
    );
  }
}
