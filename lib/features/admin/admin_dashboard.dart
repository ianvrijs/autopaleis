

import 'package:autopaleis/shared/services/repair_service.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/services/auth_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final repairService = context.read<RepairService>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
        repairService.fetchRepairs();
      });
      
    if (!context.watch<AuthService>().isAdmin) {
      return Scaffold(
        body: Center(child: Text(l10n.no_access)),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.admin_panel)),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children:  [
            _AdminCard(
              title: l10n.rentals,
              icon: Icons.car_rental,
              route: '/admin/rentals',
            ),
            _AdminCard(
              title: l10n.repairs,
              icon: Icons.build,
              route: '/admin/repairs',
            ),
            _AdminCard(
              title: l10n.damage_reports,
              icon: Icons.report_problem,
              route: '/admin/damages',
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  const _AdminCard({
    required this.title,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
