import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/services/rental_service.dart';
import '../../shared/models/rental_model.dart';

class RentalDetailsPage extends StatefulWidget {
  final int rentalId;

  const RentalDetailsPage({super.key, required this.rentalId});

  @override
  State<RentalDetailsPage> createState() => _RentalDetailsPageState();
}

class _RentalDetailsPageState extends State<RentalDetailsPage> {
  RentalModel? rental;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final data = await context.read<RentalService>().fetchRentalById(widget.rentalId);
      setState(() {
        rental = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Rental Details")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Rental Details")),
        body: Center(child: Text(error!)),
      );
    }

    final r = rental!;
    return Scaffold(
      appBar: AppBar(
        title: Text("${r.car.brand} ${r.car.model}"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // CAR
          _section(
            title: "Car",
            children: [
              Text("Merk: ${r.car.brand}"),
              Text("Model: ${r.car.model}"),
              Text("Brandstof: ${r.car.fuel}"),
              Text("Jaar: ${r.car.modelYear}"),
              Text("Zitplaatsen: ${r.car.nrOfSeats}"),
              Text("Nummerbord: ${r.car.licensePlate}"),
            ],
          ),

          // RENTAL INFO
          _section(
            title: "Rental",
            children: [
              Text("Van: ${r.fromDate}"),
              Text("Tot: ${r.toDate}"),
              Text("Staat: ${r.state}"),
              Text("Code: ${r.code}"),
              Text("Coördinaten: ${r.longitude}, ${r.latitude}"),
            ],
          ),

          // CUSTOMER
          _section(
            title: "Customer",
            children: [
              Text("Naam: ${r.customer.firstName} ${r.customer.lastName}"),
              Text("Klant Nr: ${r.customer.nr}"),
              Text("Klant sinds: ${r.customer.from}"),
            ],
          ),

          // INSPECTIONS
          _section(
            title: "Inspections",
            children: r.inspections.map((ins) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Inspectie Code: ${ins.code}"),
                    Text("Kilometerteller: ${ins.odometer}"),
                    Text("Resultaat: ${ins.result}"),
                    Text("Omschrijving: ${ins.description}"),
                    Text("Voltooid: ${ins.completed}"),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
