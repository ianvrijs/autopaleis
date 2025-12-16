import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/services/rental_service.dart';

class AdminRentalsPage extends StatefulWidget {
  const AdminRentalsPage({super.key});

  @override
  State<AdminRentalsPage> createState() => _AdminRentalsPageState();
}

class _AdminRentalsPageState extends State<AdminRentalsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<RentalService>().fetchRentals());
  }

  @override
  Widget build(BuildContext context) {
    final rentalService = context.watch<RentalService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Alle Rentals')),
      body: rentalService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: rentalService.rentalList.length,
              itemBuilder: (context, index) {
                final rental = rentalService.rentalList[index];

                return ListTile(
                  leading: const Icon(Icons.car_rental),
                  title: Text('Rental #${rental.id}'),
                  subtitle: Text(
                    'Status: ${rental.state}\n'
                    'Van ${rental.fromDate} tot ${rental.toDate}',
                  ),
                  trailing: Icon(
                    rental.state == 'RESERVED'
                        ? Icons.check_circle
                        : Icons.schedule,
                    color: rental.state == 'RESERVED'
                        ? Colors.green
                        : Colors.orange,
                  ),
                );
              },
            ),
    );
  }
}
