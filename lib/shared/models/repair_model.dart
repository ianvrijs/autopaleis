import 'car_model.dart';
import 'employee_model.dart';
import 'inspection_model.dart';

enum RepairStatus {
  planned,
  doing,
  done,
  cancelled,
  unknown,
}

class Repair {
  final int id;
  final String description;
  final RepairStatus status;
  final DateTime? dateCompleted;
  final CarModel? car;
  final EmployeeModel? employee;
  final InspectionModel? inspection;

  Repair({
    required this.id,
    required this.description,
    required this.status,
    this.dateCompleted,
    this.car,
    this.employee,
    this.inspection,
  });

  factory Repair.fromJson(Map<String, dynamic> json) {
    return Repair(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      status: _parseStatus(json['repairStatus']),
      dateCompleted: json['dateCompleted'] != null
          ? DateTime.tryParse(json['dateCompleted'])
          : null,
      car: json['car'] != null ? CarModel.fromJson(json['car']) : null,
      employee:
          json['employee'] != null ? EmployeeModel.fromJson(json['employee']) : null,
      inspection:
          json['inspection'] != null ? InspectionModel.fromJson(json['inspection']) : null,
    );
  }

  static RepairStatus _parseStatus(String? value) {
    switch (value?.toUpperCase()) {
      case 'PLANNED':
        return RepairStatus.planned;
      case 'DOING':
        return RepairStatus.doing;
      case 'DONE':
        return RepairStatus.done;
      case 'CANCELLED':
        return RepairStatus.cancelled;
      default:
        return RepairStatus.unknown;
    }
  }
}
