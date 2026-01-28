import 'package:autopaleis/core/constants/app_constants.dart';
import 'package:autopaleis/shared/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../shared/models/ride_model.dart';
import '../../shared/services/rental_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _isLoading = false;

  Future<void> _startRide(BuildContext context, int carId) async {
    setState(() => _isLoading = true);

    try {
      final rentalService = context.read<RentalService>();
      final ride = context.read<Ride>();
      final authService = context.read<AuthService>();
      final customerId = int.parse(authService.currentUser!.id);

      final position = await _determinePosition();
      final rentalSummary = await rentalService.createRental(carId, customerId);
      final activeRental = await rentalService.startRentalRide(
        rentalSummary.id,
        position.latitude,
        position.longitude,
      );
      ride.startRide(activeRental.id, activeRental.code);

      if (mounted) {
        Navigator.pushNamed(context, AppConstants.activeRideRoute);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rid starten ging fout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final carId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boeking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Boeking voor auto: $carId', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _startRide(context, carId),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Check! Start de rit.'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Locatie services zijn uitgeschakeld.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Locatie permissie is niet gegeven.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Locatie permissie zijn permanent geweigerd. We kunnen dit niet opnieuw aanvragen..');
    }

    return await Geolocator.getCurrentPosition();
  }
}
