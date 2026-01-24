import 'package:flutter/foundation.dart';

class Ride with ChangeNotifier {
  int? _activeRentalId;
  String? _activeRentalCode;

  int? get activeRentalId => _activeRentalId;
  String? get activeRentalCode => _activeRentalCode;
  bool get isRideActive => _activeRentalId != null;

  void startRide(int rentalId, String rentalCode) {
    _activeRentalId = rentalId;
    _activeRentalCode = rentalCode;
    notifyListeners();
  }

  void endRide() {
    _activeRentalId = null;
    _activeRentalCode = null;
    notifyListeners();
  }
}
