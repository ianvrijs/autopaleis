import 'package:flutter/material.dart';
import 'dart:convert';

class CarDetails extends StatelessWidget {
  final Map<String, dynamic> car;

  const CarDetails({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            _buildCarImage(car['picture'] ?? ''),
            const SizedBox(height: 16),
            // Car Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand and Model
                  Text(
                    '${car['brand']} ${car['model']}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Overview Section
                  _buildSection(
                    context,
                    title: 'Overzicht',
                    items: [
                      _InfoItem('Jaar', car['year']?.toString() ?? 'N/A'),
                      _InfoItem('Opties', car['options'] ?? 'N/A'),
                      _InfoItem('Brandstoftype', car['fuelType'] ?? 'N/A'),
                      _InfoItem('Zitplaatsen', car['seats']?.toString() ?? 'N/A'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Features Section
                  _buildSection(
                    context,
                    title: 'Kenmerken',
                    items: [
                      _InfoItem('Carrosserietype', car['body'] ?? 'N/A'),
                      _InfoItem('Motorinhoud', car['engineSize']?.toString() ?? 'N/A'),
                      _InfoItem('Kenteken', car['licensePlate']?.toString() ?? 'N/A'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Price and Book Button
                  _buildPriceAndBook(context),
                  const SizedBox(height: 16),
                  // Reviews Section
                  _buildReviewsSection(context),
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
      String base64String = imageData;
      if (imageData.contains(',')) {
        base64String = imageData.split(',')[1];
      }

      final bytes = base64.decode(base64String);
      return ClipRRect(
        child: Container(
          height: 250,
          color: Colors.grey[300],
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.directions_car, size: 80),
              );
            },
          ),
        ),
      );
    } catch (e) {
      return Container(
        height: 250,
        color: Colors.grey[300],
        child: const Icon(Icons.directions_car, size: 80),
      );
    }
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_InfoItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildInfoItem(context, items[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, _InfoItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          item.value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPriceAndBook(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prijs',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '€${car['price']}/dag',
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
              // TODO: Navigate to booking page
            },
            child: const Text('Boek Nu'),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recente Beoordelingen',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        // Rating Bar
        Container(
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
                  Text(
                    'Beoordeling',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        size: 16,
                        color: index < 4 ? Colors.amber : Colors.grey[300],
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.8,
                minHeight: 6,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Review Items
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildReviewItem(context, 'John Doe', '2024-01-15', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
              const SizedBox(height: 8),
              _buildReviewItem(context, 'Jane Smith', '2024-01-10', 'Geweldige auto, erg comfortabel en betrouwbaar. Zeer aanbevolen!'),
              const SizedBox(height: 8),
              _buildReviewItem(context, 'Mike Johnson', '2024-01-05', 'Geweldige ervaring. De auto is in perfecte staat.'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Load More Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // TODO: Load more reviews
            },
            child: const Text('Meer beoordelingen laden'),
          ),
        ),
        const SizedBox(height: 8),
        // Write Review Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Navigate to write review page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            child: const Text('Schrijf een beoordeling'),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(
    BuildContext context,
    String name,
    String date,
    String reviewText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              date,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              Icons.star,
              size: 14,
              color: index < 4 ? Colors.amber : Colors.grey[300],
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          reviewText,
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem(this.label, this.value);
}
