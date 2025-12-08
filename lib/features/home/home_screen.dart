import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../core/constants/app_constants.dart';
import 'package:autopaleis/shared/services/car_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarService>().fetchCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
            },
          ),
          IconButton(
            icon: const Icon(Icons.star),
            tooltip: "My Reviews",
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.myReviewsRoute);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bus_alert),
            tooltip: "My Rentals",
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.myRentalsRoute);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.welcomeMessage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<CarService>(
                builder: (context, carService, child) {
                  if (carService.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (carService.error != null) {
                    return Center(child: Text(carService.error!));
                  }

                  if (carService.carList.isEmpty) {
                    return const Center(child: Text('No cars available'));
                  }

                  return ListView.separated(
                    itemCount: carService.carList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final car = carService.carList[index];
                      return _buildRentalCarCard(
                        context,
                        imageUrl: car.picture,
                        brand: car.brand,
                        model: car.model,
                        carType: car.body.name,
                        distance: '2.5 km', // Calculate from lat/long
                        price: '€${car.price}/day',
                        onTap: () {
                          // Navigate to car details
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRentalCarCard(
    BuildContext context, {
    required String imageUrl,
    required String brand,
    required String model,
    required String carType,
    required String distance,
    required String price,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Left column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand | Model
                    Text(
                      '$brand | $model',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Car body
                    Text(
                      carType,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 24),
                    // Distance and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          distance,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        Text(
                          price,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right column
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildCarImage(imageUrl),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarImage(String imageData) {
    try {
      // Remove data URL prefix if present
      String base64String = imageData;
      if (imageData.contains(',')) {
        base64String = imageData.split(',')[1];
      }
      
      final bytes = base64.decode(base64String);
      return Image.memory(
        bytes,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } catch (e) {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 100,
      color: Colors.grey[300],
      child: const Icon(Icons.directions_car, size: 40),
    );
  }
}
