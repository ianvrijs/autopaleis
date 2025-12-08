import 'car_model.dart';
import 'inspection_model.dart';
import 'customer_model.dart';

enum RentalState {
  active,
  reserved,
  pickup,
  returned,
}

class RentalModel {
  final int id;
  final String code;
  final double longitude;
  final double latitude;
  final String fromDate;
  final String toDate;
  final RentalState state;
  final List<InspectionModel> inspections;
  final CustomerModel customer;
  final CarModel car;

  RentalModel({
    required this.id,
    required this.code,
    required this.longitude,
    required this.latitude,
    required this.fromDate,
    required this.toDate,
    required this.state,
    required this.inspections,
    required this.customer,
    required this.car,
  });

  factory RentalModel.fromJson(Map<String, dynamic> json) {
    return RentalModel(
      id: json['id'] as int,
      code: json['code'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      fromDate: json['fromDate'] as String,
      toDate: json['toDate'] as String,
      state: _parseRentalState(json['state'] as String),

      inspections: json['inspections'] != null
          ? (json['inspections'] as List<dynamic>)
              .map((i) => InspectionModel.fromJson(i))
              .toList()
          : [],

      customer: CustomerModel.fromJson(json['customer']),
      car: CarModel.fromJson(json['car']),
    );
  }

  static RentalState _parseRentalState(String value) {
    switch (value.toUpperCase()) {
      case 'ACTIVE':
        return RentalState.active;
      case 'RESERVED':
        return RentalState.reserved;
      case 'PICKUP':
        return RentalState.pickup;
      case 'RETURNED':
        return RentalState.returned;
      default:
        return RentalState.active;
    }
  }
}
