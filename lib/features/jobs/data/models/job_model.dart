class JobModel {
  final String id;
  final String? jrCode;

  final String title;
  final String? description;

  final String? companyName;
  final String? department;
  final String? location;

  final int? minExperience;
  final int? maxExperience;

  final int? salaryMin;
  final int? salaryMax;

  final int? openings;

  final String? skills;
  final String? education;

  final String? status;

  final DateTime? requestDate;
  final DateTime? closureDate;

  final DateTime createdAt;

  final String? createdByName;
  final String? createdByEmail;

  final int? applicationsCount;

  JobModel({
    required this.id,
    required this.title,
    required this.createdAt,

    this.jrCode,
    this.description,

    this.companyName,
    this.department,
    this.location,

    this.minExperience,
    this.maxExperience,

    this.salaryMin,
    this.salaryMax,

    this.openings,

    this.skills,
    this.education,

    this.status,

    this.requestDate,
    this.closureDate,

    this.createdByName,
    this.createdByEmail,

    this.applicationsCount,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],

      jrCode: json['jrCode'],

      title: json['title'],

      description: json['description'],

      companyName: json['companyName'],
      department: json['department'],
      location: json['location'],

      minExperience: json['minExperience'],
      maxExperience: json['maxExperience'],

      salaryMin: json['salaryMin'],
      salaryMax: json['salaryMax'],

      openings: json['openings'],

      skills: json['skills'],
      education: json['education'],

      status: json['status'],

      requestDate: json['requestDate'] != null
          ? DateTime.parse(json['requestDate'])
          : null,

      closureDate: json['closureDate'] != null
          ? DateTime.parse(json['closureDate'])
          : null,

      createdAt: DateTime.parse(json['createdAt']),

      createdByName: json['createdBy']?['name'],
      createdByEmail: json['createdBy']?['email'],

      applicationsCount: json['_count']?['applications'],
    );
  }
}
