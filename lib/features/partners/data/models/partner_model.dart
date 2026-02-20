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
    return PartnerModel(
      id: json['id'],

      // FIX: correct backend field name
      businessName: json['organisationName'],

      // FIX: correct backend field name
      phone: json['contactNumber'],

      status: json['status'],

      createdAt: DateTime.parse(json['createdAt']),

      userId: json['user']['id'],
      userName: json['user']['name'],
      userEmail: json['user']['email'],
    );
  }
}
