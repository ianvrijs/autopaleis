class CustomerModel {
  final int id;
  final int nr;
  final String lastName;
  final String firstName;
  final String from;

  CustomerModel({
    required this.id,
    required this.nr,
    required this.lastName,
    required this.firstName,
    required this.from,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int,
      nr: json['nr'] as int,
      lastName: json['lastName'] as String,
      firstName: json['firstName'] as String,
      from: json['from'] as String,
    );
  }
}
