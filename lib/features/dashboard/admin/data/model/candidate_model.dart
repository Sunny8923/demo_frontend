class Candidate {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? location;
  final double? experience;
  final String? company;
  final String? designation;
  final List<String> skills;
  final String? qualification;
  final String? resume;

  Candidate({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.location,
    this.experience,
    this.company,
    this.designation,
    required this.skills,
    this.qualification,
    this.resume,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json["id"],
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      location: json["currentLocation"],
      experience: (json["totalExperience"] as num?)?.toDouble(),
      company: json["currentCompany"],
      designation: json["currentDesignation"],
      skills: (json["skillsArray"] as List?)?.cast<String>() ?? [],
      qualification: json["highestQualification"],
      resume: json["resume"],
    );
  }
}
