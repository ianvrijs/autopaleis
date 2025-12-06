
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
        id: json['id'] as int,
        brand: json['brand'] as String,
        model: json['model'] as String,
        picture: json['picture'] as String,
        pictureContentType: json['pictureContentType'] as String,
        fuel: _parseFuelType(json['fuel'] as String),
        options: json['options'] as String,
        licensePlate: json['licensePlate'] as String,
        engineSize: json['engineSize'] as int,
        modelYear: json['modelYear'] as int,
        since: json['since'] as String,
        price: json['price'] as double,
        nrOfSeats: json['nrOfSeats'] as int,
        body: _parseBodyType(json['body'] as String),
        longitude: json['longitude'] as double,
        latitude: json['latitude'] as double);
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
