class JobCreatorModel {
  final String id;
  final String name;
  final String email;

  JobCreatorModel({required this.id, required this.name, required this.email});

  factory JobCreatorModel.fromJson(Map<String, dynamic> json) {
    return JobCreatorModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
