import 'package:flutter/material.dart';

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({super.key});

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> reviews = [
    {
      "car": "Volkswagen Golf",
      "rating": 4,
      "review":
          "Fijne auto om in te rijden. Goede service!",
      "date": "12 feb 2025"
    },
    {
      "car": "BMW 3 Serie",
      "rating": 5,
      "review": "Fantastische ervaring! Zeker aan te raden.",
      "date": "2 jan 2025"
    },
    {
      "car": "Toyota Aygo",
      "rating": 3,
      "review": "Prima auto, maar iets te klein voor lange ritten.",
      "date": "21 dec 2024"
    },
  ];

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    // Filter reviews op basis van search
    final filteredReviews = reviews.where((r) {
      final query = searchText.toLowerCase();
      return r["car"].toLowerCase().contains(query) ||
          r["review"].toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mijn Reviews"),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Zoek in je reviews...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Review cards
          Expanded(
            child: ListView.builder(
              itemCount: filteredReviews.length,
              itemBuilder: (context, index) {
                final review = filteredReviews[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ReviewCard(
                    car: review["car"],
                    rating: review["rating"],
                    review: review["review"],
                    date: review["date"],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String car;
  final int rating;
  final String review;
  final String date;

  const ReviewCard({
    super.key,
    required this.car,
    required this.rating,
    required this.review,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car title + rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  car,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Rating stars
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Review text
            Text(
              review,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 12),

            // Date
            Text(
              date,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
