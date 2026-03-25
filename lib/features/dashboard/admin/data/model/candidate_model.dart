class Candidate {
  final String id;
  final String name;
  final String email;
  final String phone;

  // Location
  final String? location;
  final String? preferredLocations;
  final String? hometown;
  final String? pincode;

  // Professional
  final double? experience;
  final String? company;
  final String? designation;
  final String? department;
  final String? industry;

  // Skills
  final List<String> skills;

  // Salary / Notice
  final double? currentSalary;
  final double? expectedSalary;
  final int? noticePeriodDays;

  // Education
  final String? qualification;

  // Resume
  final String? resume;

  Candidate({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,

    this.location,
    this.preferredLocations,
    this.hometown,
    this.pincode,

    this.experience,
    this.company,
    this.designation,
    this.department,
    this.industry,

    required this.skills,

    this.currentSalary,
    this.expectedSalary,
    this.noticePeriodDays,

    this.qualification,
    this.resume,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json["id"],
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",

      // Location
      location: json["currentLocation"],
      preferredLocations: json["preferredLocations"],
      hometown: json["hometown"],
      pincode: json["pincode"],

      // Professional
      experience: (json["totalExperience"] as num?)?.toDouble(),
      company: json["currentCompany"],
      designation: json["currentDesignation"],
      department: json["department"],
      industry: json["industry"],

      // Skills
      skills: (json["skillsArray"] as List?)?.cast<String>() ?? [],

      // Salary / Notice
      currentSalary: (json["currentSalary"] as num?)?.toDouble(),
      expectedSalary: (json["expectedSalary"] as num?)?.toDouble(),
      noticePeriodDays: json["noticePeriodDays"],

      // Education
      qualification: json["highestQualification"],

      // Resume
      resume: json["resume"],
    );
  }
}
