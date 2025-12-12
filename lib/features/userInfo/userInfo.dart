import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/services/auth_service.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accountgegevens'),
        elevation: 0,
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, _) {
          final user = authService.currentUser;

          if (user == null) {
            return const Center(
              child: Text('Geen gebruikersgegevens beschikbaar'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar Section
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: const Icon(Icons.person, size: 50),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // User Info Fields
                _buildInfoSection(
                  context,
                  label: 'Gebruikersnaam',
                  value: user.username,
                ),
                const SizedBox(height: 16),
                _buildInfoSection(
                  context,
                  label: 'E-mailadres',
                  value: user.email,
                ),
                const SizedBox(height: 16),
                _buildInfoSection(
                  context,
                  label: 'Voornaam',
                  value: user.firstName ?? 'Niet ingesteld',
                ),
                const SizedBox(height: 16),
                _buildInfoSection(
                  context,
                  label: 'Achternaam',
                  value: user.lastName ?? 'Niet ingesteld',
                ),
                const SizedBox(height: 32),
                // Edit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppConstants.editUserInfoRoute);
                    },
                    child: const Text('Profiel Bewerken'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
