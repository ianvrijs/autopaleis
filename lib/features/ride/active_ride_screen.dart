import 'package:autopaleis/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../shared/models/ride_model.dart';
import '../../shared/services/rental_service.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  bool _isEndingRide = false;

  Future<void> _endRide() async {
    setState(() => _isEndingRide = true);

    try {
      final position = await _determinePosition();

      final ride = context.read<Ride>();
      final rentalService = context.read<RentalService>();

      await rentalService.endRentalRide(
        ride.activeRentalId!,
        position.latitude,
        position.longitude,
      );

      ride.endRide();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppConstants.homeRoute, 
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kon rit niet eindigen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isEndingRide = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = context.watch<Ride>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rit Bezig'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.drive_eta, size: 100, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                'Goede reis!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (ride.activeRentalCode != null && ride.activeRentalCode!.isNotEmpty)
                Text(
                  'Uw reserveringscode: ${ride.activeRentalCode}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isEndingRide ? null : _endRide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: _isEndingRide
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Beëindig Rit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Determine the current position of the device.
  /// When location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
