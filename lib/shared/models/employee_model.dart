class EmployeeModel {
  final int id;
  final int nr;
  final String firstName;
  final String lastName;
  final DateTime? from;

  EmployeeModel({
    required this.id,
    required this.nr,
    required this.firstName,
    required this.lastName,
    this.from,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      nr: json['nr'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      from: json['from'] != null ? DateTime.tryParse(json['from']) : null,
    );
  }

  String get fullName => '$firstName $lastName';
}
