import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/services/rental_service.dart';
import '../../shared/models/rental_model.dart';
import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.rental_details)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.rental_details)),
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
            title: l10n.car,
            children: [
              Text("${l10n.brand}: ${r.car.brand}"),
              Text("${l10n.model}: ${r.car.model}"),
              Text("${l10n.fuel_type}: ${r.car.fuel}"),
              Text("${l10n.year}: ${r.car.modelYear}"),
              Text("${l10n.seats}: ${r.car.nrOfSeats}"),
              Text("${l10n.license_plate}: ${r.car.licensePlate}"),
            ],
          ),

          // RENTAL INFO
          _section(
            title: l10n.rental,
            children: [
              Text("${l10n.from}: ${r.fromDate}"),
              Text("${l10n.to}: ${r.toDate}"),
              Text("${l10n.status}: ${r.state}"),
              Text("Code: ${r.code}"),
              Text("${l10n.coordinates}: ${r.longitude}, ${r.latitude}"),
            ],
          ),

          // CUSTOMER
          _section(
            title: l10n.customer,
            children: [
              Text("${l10n.name}: ${r.customer.firstName} ${r.customer.lastName}"),
              Text("${l10n.customer_nr}: ${r.customer.nr}"),
              Text("${l10n.customer_since}: ${r.customer.from}"),
            ],
          ),

          // INSPECTIONS
          _section(
            title: l10n.inspections,
            children: r.inspections.map((ins) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${l10n.inspection_code}: ${ins.code}"),
                    Text("${l10n.odometer}: ${ins.odometer}"),
                    Text("${l10n.result}: ${ins.result}"),
                    Text("${l10n.description}: ${ins.description}"),
                    Text("${l10n.completed}: ${ins.completed}"),
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
