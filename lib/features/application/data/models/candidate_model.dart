class CandidateModel {
  final String id;

  /// Basic identity
  final String name;
  final String email;
  final String phone;

  /// Location info
  final String? currentLocation;
  final String? preferredLocations;
  final String? hometown;
  final String? pincode;

  /// Professional info
  final double? totalExperience;
  final String? currentCompany;
  final String? currentDesignation;
  final String? department;
  final String? industry;
  final String? skills;

  final double? currentSalary;
  final double? expectedSalary;
  final int? noticePeriodDays;

  /// Education info
  final String? highestQualification;
  final String? specialization;
  final String? university;
  final int? graduationYear;

  /// Personal info
  final DateTime? dateOfBirth;
  final String? gender;
  final String? maritalStatus;

  /// Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  const CandidateModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,

    this.currentLocation,
    this.preferredLocations,
    this.hometown,
    this.pincode,

    this.totalExperience,
    this.currentCompany,
    this.currentDesignation,
    this.department,
    this.industry,
    this.skills,

    this.currentSalary,
    this.expectedSalary,
    this.noticePeriodDays,

    this.highestQualification,
    this.specialization,
    this.university,
    this.graduationYear,

    this.dateOfBirth,
    this.gender,
    this.maritalStatus,

    required this.createdAt,
    required this.updatedAt,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      id: json['id'],

      name: json['name'],
      email: json['email'],
      phone: json['phone'],

      currentLocation: json['currentLocation'],
      preferredLocations: json['preferredLocations'],
      hometown: json['hometown'],
      pincode: json['pincode'],

      totalExperience: json['totalExperience'] != null
          ? (json['totalExperience'] as num).toDouble()
          : null,

      currentCompany: json['currentCompany'],
      currentDesignation: json['currentDesignation'],
      department: json['department'],
      industry: json['industry'],
      skills: json['skills'],

      currentSalary: json['currentSalary'] != null
          ? (json['currentSalary'] as num).toDouble()
          : null,

      expectedSalary: json['expectedSalary'] != null
          ? (json['expectedSalary'] as num).toDouble()
          : null,

      noticePeriodDays: json['noticePeriodDays'],

      highestQualification: json['highestQualification'],
      specialization: json['specialization'],
      university: json['university'],
      graduationYear: json['graduationYear'],

      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,

      gender: json['gender'],
      maritalStatus: json['maritalStatus'],

      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,

      "currentLocation": currentLocation,
      "preferredLocations": preferredLocations,
      "hometown": hometown,
      "pincode": pincode,

      "totalExperience": totalExperience,
      "currentCompany": currentCompany,
      "currentDesignation": currentDesignation,
      "department": department,
      "industry": industry,
      "skills": skills,

      "currentSalary": currentSalary,
      "expectedSalary": expectedSalary,
      "noticePeriodDays": noticePeriodDays,

      "highestQualification": highestQualification,
      "specialization": specialization,
      "university": university,
      "graduationYear": graduationYear,

      "dateOfBirth": dateOfBirth?.toIso8601String(),
      "gender": gender,
      "maritalStatus": maritalStatus,
    };
  }
}
