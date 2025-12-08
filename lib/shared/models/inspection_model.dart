class InspectionModel {
  final int id;
  final String code;
  final int odometer;
  final String result;
  final String description;
  final String photo;
  final String photoContentType;
  final String completed;

  InspectionModel({
    required this.id,
    required this.code,
    required this.odometer,
    required this.result,
    required this.description,
    required this.photo,
    required this.photoContentType,
    required this.completed,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      id: json['id'] as int,
      code: json['code'] as String,
      odometer: json['odometer'] as int,
      result: json['result'] as String,
      description: json['description'] as String,
      photo: json['photo'] as String,
      photoContentType: json['photoContentType'] as String,
      completed: json['completed'] as String,
    );
  }
}
