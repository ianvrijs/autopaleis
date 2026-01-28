import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/services/repair_service.dart';
import '../../../shared/models/repair_model.dart';
import '../../../l10n/app_localizations.dart';

class AdminRepairsPage extends StatefulWidget {
  const AdminRepairsPage({super.key});

  @override
  State<AdminRepairsPage> createState() => _AdminRepairsPageState();
}

class _AdminRepairsPageState extends State<AdminRepairsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RepairService>().fetchRepairs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!context.watch<AuthService>().isAdmin) {
      return const Scaffold(
        body: Center(child: Text('Geen toegang')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.repairs_overview),
      ),
      body: Consumer<RepairService>(
        builder: (context, repairService, _) {
          if (repairService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (repairService.error != null) {
            return Center(child: Text(repairService.error!));
          }

          if (repairService.repairs.isEmpty) {
            return Center(child: Text(l10n.no_repairs_found));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: repairService.repairs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final repair = repairService.repairs[index];

              return Card(
                child: ListTile(
                  leading: _statusIcon(repair.status),
                  title: Text(
                    repair.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${l10n.license_plate}: ${repair.car?.licensePlate ?? '—'}'),
                      Text('${l10n.mechanic}: ${repair.employee?.fullName ?? l10n.not_assigned}'),
                      Text('${l10n.status}: ${_statusText(repair.status, l10n)}'), // reused status
                      if (repair.dateCompleted != null)
                        Text(
                          '${l10n.completed}: ${repair.dateCompleted!.toLocal().toString().split(' ')[0]}',
                        ),
                    ],
                  ),
                  onTap: () {
                    // TODO: details pagina
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Icon _statusIcon(RepairStatus status) {
    switch (status) {
      case RepairStatus.planned:
        return const Icon(Icons.schedule, color: Colors.orange);
      case RepairStatus.doing:
        return const Icon(Icons.build, color: Colors.blue);
      case RepairStatus.done:
        return const Icon(Icons.check_circle, color: Colors.green);
      case RepairStatus.unknown:
        return const Icon(Icons.help_outline, color: Colors.grey);
      case RepairStatus.cancelled:
        return const Icon(Icons.cancel, color: Colors.red);
    }
  }

  String _statusText(RepairStatus status, AppLocalizations l10n) {
    switch (status) {
      case RepairStatus.planned:
        return l10n.status_planned;
      case RepairStatus.doing:
        return l10n.status_doing;
      case RepairStatus.done:
        return l10n.status_done; // Or reuse l10n.completed if you want
      case RepairStatus.unknown:
        return l10n.status_unknown;
      case RepairStatus.cancelled:
        return l10n.status_cancelled;
    }
  }
}
