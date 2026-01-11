import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../shared/models/car_model.dart';
import '../../shared/services/favorites_service.dart';

class CarCard extends StatelessWidget {
  final CarModel car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final favoritesService = context.watch<FavoritesService>();
    final carId = car.id.toString();
    final isFavorite = favoritesService.isFavorite(carId);

    final carData = {
      'id': car.id,
      'brand': car.brand,
      'model': car.model,
      'picture': car.picture,
      'price': car.price,
      'body': car.body.name,
      'year': car.modelYear,
      'options': car.options,
      'fuelType': car.fuel.name,
      'seats': car.nrOfSeats,
      'engineSize': car.engineSize.toString(),
      'licensePlate': car.licensePlate,
      'since': car.since,
    };

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppConstants.carDetailsRoute,
            arguments: carData,
          );
        },
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
                    // Brand | Model with Favorite Icon
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${car.brand} | ${car.model}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () => favoritesService.toggleFavorite(carId),
                          child: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Car body
                    Text(
                      car.body.name,
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
                          '2.5 km',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        Text(
                          '€${car.price}/day',
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
                  child: _buildCarImage(car.picture),
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
