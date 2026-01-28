class RentalSummary {
  final int id;

  RentalSummary({required this.id});

  factory RentalSummary.fromJson(Map<String, dynamic> json) {
    return RentalSummary(
      id: json['id'] ?? 0,
    );
  }
}
