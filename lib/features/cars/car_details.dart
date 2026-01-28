import 'package:autopaleis/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../shared/services/favorites_service.dart';
import '../../shared/services/reviews_service.dart';
import '../../shared/models/review_model.dart';

class CarDetails extends StatelessWidget {
  final Map<String, dynamic> car;

  const CarDetails({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final favoritesService = context.watch<FavoritesService>();

    final carId = FavoritesService.getCarId(car);
    final isFavorite = favoritesService.isFavorite(carId);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.car_details),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarImage(car['picture'] ?? ''),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Titel + favoriet
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${car['brand']} ${car['model']}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () =>
                            favoritesService.toggleFavorite(carId),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildSection(
                    context,
                    title: l10n.overview,
                    items: [
                      _InfoItem(l10n.year, car['year']?.toString() ?? l10n.na),
                      _InfoItem(l10n.options, car['options'] ?? l10n.na),
                      _InfoItem(l10n.fuel_type, car['fuelType'] ?? l10n.na),
                      _InfoItem(l10n.seats, car['seats']?.toString() ?? l10n.na),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildSection(
                    context,
                    title: l10n.features,
                    items: [
                      _InfoItem(l10n.body_type, car['body'] ?? l10n.na),
                      _InfoItem(l10n.engine_size, car['engineSize']?.toString() ?? l10n.na),
                      _InfoItem(l10n.license_plate, car['licensePlate']?.toString() ?? l10n.na),
                    ],
                  ),

                  const SizedBox(height: 16),
                  // Price and Book Button
                  _buildPriceAndBook(context, l10n),
                  const SizedBox(height: 16),
                  // Reviews Section
                  _buildReviewsSection(context, l10n),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarImage(String imageData) {
    try {
      final base64String =
          imageData.contains(',') ? imageData.split(',')[1] : imageData;
      final bytes = base64.decode(base64String);

      return Image.memory(
        bytes,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imageFallback(),
      );
    } catch (_) {
      return _imageFallback();
    }
  }

  Widget _imageFallback() {
    return Container(
      height: 250,
      color: Colors.grey[300],
      child: const Icon(Icons.directions_car, size: 80),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_InfoItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => _buildInfoItem(context, items[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, _InfoItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 2),
        Text(
          item.value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPriceAndBook(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.price,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.price_per_day(car['price'].toString()),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.bookingRoute, arguments: car['id']);
            },
            child: Text(l10n.book_now),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context, AppLocalizations l10n) {
    // final favoritesService = context.watch<FavoritesService>();
    final reviewsService = context.watch<ReviewsService>();

    final carId = FavoritesService.getCarId(car);
    final reviews = reviewsService.getReviews(carId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recent_reviews,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        // Rating Bar

        // Review Items
        if (!reviews.isEmpty)
          ...reviews.map((review) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildReviewItem(context, review),
              )),

        const SizedBox(height: 12),

        // Write Review Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showAddReviewDialog(context, carId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            child: Text(l10n.write_review),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(BuildContext context, ReviewModel review) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review.author,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Text(
                review.date.toString().split(' ').first,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(5, (i) {
              return Icon(
                Icons.star,
                size: 14,
                color: i < review.rating
                    ? Colors.amber
                    : Colors.grey[300],
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(review.comment),
        ],
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context, String carId) {
    final commentController = TextEditingController();
    int rating = 5;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nieuwe beoordeling'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<int>(
              value: rating,
              items: List.generate(
                5,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text('${i + 1} sterren'),
                ),
              ),
              onChanged: (v) => rating = v!,
            ),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration:
                  const InputDecoration(hintText: 'Jouw ervaring'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ReviewsService>().addReview(
                    carId,
                    ReviewModel(
                      author: 'Gebruiker',
                      comment: commentController.text,
                      rating: rating,
                      date: DateTime.now(),
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Opslaan'),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem(this.label, this.value);
}
