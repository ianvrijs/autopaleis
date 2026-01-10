import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/services/auth_service.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mijn Profiel'),
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
              title: 'Mijn Boekingen',
              icon: Icons.calendar_today,
              onTap: () {
                Navigator.pushNamed(context, AppConstants.myRentalsRoute);
              },
            ),
            _buildMenuSection(
              context,
              title: 'Favoriete Auto\'s',
              icon: Icons.favorite,
              onTap: () {
                Navigator.pushNamed(context, AppConstants.favoritesRoute);
              },
            ),
            _buildMenuSection(
              context,
              title: 'Accountgegevens',
              icon: Icons.info,
              onTap: () {
                Navigator.pushNamed(context, AppConstants.userInfoRoute);
              },
            ),
            _buildMenuSection(
              context,
              title: 'Afmelden',
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Afmelden'),
          content: const Text('Weet je zeker dat je wilt afmelden?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuleren'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthService>().logout();
                Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
              },
              child: const Text('Afmelden', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
