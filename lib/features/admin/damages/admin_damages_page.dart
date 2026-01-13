import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/services/repair_service.dart';
import '../../../shared/models/repair_model.dart';

class AdminDamagesPage extends StatelessWidget {
  const AdminDamagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!context.watch<AuthService>().isAdmin) {
      return const Scaffold(
        body: Center(child: Text('Geen toegang')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schademeldingen afhandelen'),
      ),
      body: Consumer<RepairService>(
        builder: (context, repairService, _) {
          if (repairService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final openRepairs = repairService.repairs
              .where((r) => r.status != RepairStatus.done)
              .toList();

          if (openRepairs.isEmpty) {
            return const Center(
              child: Text('Geen openstaande schades'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: openRepairs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final repair = openRepairs[index];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.report_problem, color: Colors.red),
                  title: Text(
                    repair.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kenteken: ${repair.car?.licensePlate ?? '-'}'),
                      Text('Status: ${repair.status.name.toUpperCase()}'),
                    ],
                  ),
                  trailing: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Afhandelen'),
                    onPressed: () async {
                      final confirmed = await _confirmDialog(context);

                      if (confirmed) {
                        await context
                            .read<RepairService>()
                            .markRepairAsDone(repair.id);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _confirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Reparatie afhandelen'),
            content: const Text(
              'Weet je zeker dat je deze schade als afgehandeld wilt markeren?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuleren'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Bevestigen'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
