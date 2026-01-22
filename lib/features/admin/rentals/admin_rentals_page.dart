import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/services/rental_service.dart';
import '../../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.all_rentals)),
      body: rentalService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: rentalService.rentalList.length,
              itemBuilder: (context, index) {
                final rental = rentalService.rentalList[index];

                return ListTile(
                  leading: const Icon(Icons.car_rental),
                  title: Text('${l10n.rental} ${rental.code}'),
                  subtitle: Text(
                    '${l10n.status}: ${rental.state}\n'
                    '${l10n.from_date_to_date(rental.fromDate.toString(), rental.toDate.toString())}',
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
