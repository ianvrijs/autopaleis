import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/services/rental_service.dart';
import '../../shared/models/rental_model.dart';
import './rental_details_page.dart';

class MyRentalsPage extends StatefulWidget {
  const MyRentalsPage({super.key});

  @override
  State<MyRentalsPage> createState() => _MyRentalsPageState();
}

class _MyRentalsPageState extends State<MyRentalsPage> {
  String searchText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<RentalService>().fetchRentals(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Rentals"),
      ),
      body: Consumer<RentalService>(
        builder: (context, rentalService, child) {
          if (rentalService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (rentalService.error != null) {
            return Center(child: Text(rentalService.error!));
          }

          List<RentalModel> rentals = rentalService.rentalList;

          // Search filtering
          final filteredRentals = rentals.where((r) {
            final q = searchText.toLowerCase();
            return r.car.brand.toLowerCase().contains(q) ||
                   r.car.model.toLowerCase().contains(q) ||
                   r.fromDate.toLowerCase().contains(q) ||
                   r.toDate.toLowerCase().contains(q);
          }).toList();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) => setState(() => searchText = value),
                  decoration: InputDecoration(
                    hintText: "Zoek in je rentals...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Rentals List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredRentals.length,
                  itemBuilder: (context, index) {
                    final rental = filteredRentals[index];
                    return RentalCard(rental: rental);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RentalCard extends StatelessWidget {
  final RentalModel rental;

  const RentalCard({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    final car = rental.car;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RentalDetailsPage(rentalId: rental.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${car.brand} ${car.model}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "${rental.fromDate} → ${rental.toDate}",
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 12),
              Text(
                rental.state.name.toUpperCase(),
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
