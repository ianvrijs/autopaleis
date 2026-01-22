import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/locale_service.dart';
import '../../l10n/app_localizations.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.my_profile),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            // Main Menu Sections
            _buildMenuSection(
              context,
              title: l10n.my_rentals,
              icon: Icons.calendar_today,
              onTap: () {
                Navigator.pushNamed(context, AppConstants.myRentalsRoute);
              },
            ),
            _buildMenuSection(
              context,
              title: l10n.favorite_cars,
              icon: Icons.favorite,
              onTap: () {
                Navigator.pushNamed(context, AppConstants.favoritesRoute);
              },
            ),
            _buildMenuSection(
              context,
              title: l10n.account_details,
              icon: Icons.info,
              onTap: () {
                Navigator.pushNamed(context, AppConstants.userInfoRoute);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Consumer<LocaleService>(
                builder: (context, localeService, _) {
                  final currentLocale = localeService.locale?.languageCode == 'nl' 
                      ? const Locale('nl') 
                      : const Locale('en');
                      
                  return ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      l10n.language,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<Locale>(
                        value: currentLocale,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onChanged: (Locale? newLocale) {
                          if (newLocale != null) {
                            localeService.setLocale(newLocale);
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            value: const Locale('en'),
                            child: Text(l10n.english),
                          ),
                          DropdownMenuItem(
                            value: const Locale('nl'),
                            child: Text(l10n.dutch),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildMenuSection(
              context,
              title: l10n.logout,
              icon: Icons.logout,
              onTap: () {
                _showLogoutDialog(context);
              },
              isDestructive: true,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: const Icon(Icons.person, size: 40),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Consumer<AuthService>(
              builder: (context, authService, child) {

                final user = authService.currentUser;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user!.username,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black87,
            fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Add this line

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.logout), // Now l10n is available
          content: Text(l10n.logout_confirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthService>().logout();
                Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
              },
              child: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
