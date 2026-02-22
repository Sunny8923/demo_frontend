class PartnerModel {
  final String id;
  final String businessName;
  final String phone;
  final String status;
  final DateTime createdAt;

  final String userId;
  final String userName;
  final String userEmail;

  PartnerModel({
    required this.id,
    required this.businessName,
    required this.phone,
    required this.status,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    ////////////////////////////////////////////////////////////
    /// SAFE user parsing
    ////////////////////////////////////////////////////////////

    final user = json['user'];

    return PartnerModel(
      id: json['id'] ?? "",

      businessName: json['organisationName'] ?? "",

      phone: json['contactNumber'] ?? "",

      status: json['status'] ?? "PENDING",

      createdAt: DateTime.tryParse(json['createdAt'] ?? "") ?? DateTime.now(),

      ////////////////////////////////////////////////////////////
      /// SAFE fallback logic
      ////////////////////////////////////////////////////////////
      userId: user != null ? user['id'] ?? "" : json['userId'] ?? "",

      userName: user != null ? user['name'] ?? "Unknown" : "Unknown",

      userEmail: user != null ? user['email'] ?? "" : "",
    );
  }
}
