
enum FuelType {
  gasoline,
  diesel,
  hybrid,
  electric
}

enum BodyType {
    stationwagon,
    sedan,
    hatchback,
    minivan,
    mpv,
    suv,
    coupe,
    truck,
    convertible
}

class CarModel {
  final int id;
  final String brand;
  final String model;
  final String picture;
  final String pictureContentType;
  final FuelType fuel;
  final String options;
  final String licensePlate;
  final int engineSize;
  final int modelYear;
  final String since;
  final double price;
  final int nrOfSeats;
  final BodyType body;
  final double longitude;
  final double latitude;

  CarModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.picture,
    required this.pictureContentType,
    required this.fuel,
    required this.options,
    required this.licensePlate,
    required this.engineSize,
    required this.modelYear,
    required this.since,
    required this.price,
    required this.nrOfSeats,
    required this.body,
    required this.longitude,
    required this.latitude
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      brand: json['brand'] as String? ?? 'N/A',
      model: json['model'] as String? ?? 'N/A',
      picture: json['picture'] as String? ?? '',
      pictureContentType: json['pictureContentType'] as String? ?? '',
      fuel: json['fuel'] != null ? _parseFuelType(json['fuel'] as String) : FuelType.gasoline,
      options: json['options'] as String? ?? '',
      licensePlate: json['licensePlate'] as String? ?? 'N/A',
      engineSize: (json['engineSize'] as num?)?.toInt() ?? 0,
      modelYear: (json['modelYear'] as num?)?.toInt() ?? 2000,
      since: json['since'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      nrOfSeats: (json['nrOfSeats'] as num?)?.toInt() ?? 0,
      body: json['body'] != null ? _parseBodyType(json['body'] as String) : BodyType.sedan,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0
    );
  }

  static FuelType _parseFuelType(String value) {
    switch (value.toUpperCase()) {
      case 'GASOLINE':
        return FuelType.gasoline;
      case 'DIESEL':
        return FuelType.diesel;
      case 'HYBRID':
        return FuelType.hybrid;
      case 'ELECTRIC':
        return FuelType.electric;
      default:
        return FuelType.gasoline; // default fallback
    }
  }

  static BodyType _parseBodyType(String value) {
    switch (value.toUpperCase()) {
      case 'STATIONWAGON':
        return BodyType.stationwagon;
      case 'SEDAN':
        return BodyType.sedan;
      case 'HATCHBACK':
        return BodyType.hatchback;
      case 'MINIVAN':
        return BodyType.minivan;
      case 'MPV':
        return BodyType.mpv;
      case 'SUV':
        return BodyType.suv;
      case 'COUPE':
        return BodyType.coupe;
      case 'TRUCK':
        return BodyType.truck;
      case 'CONVERTIBLE':
        return BodyType.convertible;
      default:
        return BodyType.sedan;
    }
  }
}
