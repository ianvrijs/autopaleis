import 'package:autopaleis/shared/services/favorites_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/car_service.dart';
import '../../shared/services/rental_service.dart';
import '../../shared/services/repair_service.dart';
import '../../shared/services/email_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final l10n = AppLocalizations.of(context)!;
      final authService = context.read<AuthService>();
      final carService = context.read<CarService>();
      final rentalService = context.read<RentalService>();
      final repairService = context.read<RepairService>();
      final favoritesService = context.read<FavoritesService>();
      
      final success = await authService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (mounted) {        
        if (success) {
          carService.setAuthToken(authService.token!);
          rentalService.setAuthToken(authService.token!);
          repairService.setAuthToken(authService.token!);
          favoritesService.setAuthToken(authService.token!);
          // Pushed home bovenop de screens stack. Dus als je op terug klikt ga je terug naar login
          Navigator.pushNamed(context, AppConstants.homeRoute);

          // Vervangt huidige screen op screens stack. Dus als je op terug klikt ga je niet terug naar login
          // Navigator.pushReplacementNamed(context, AppConstants.homeRoute);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authService.error ?? l10n.login_failed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleGitHubLogin() async {
    final l10n = AppLocalizations.of(context)!;
    final authService = context.read<AuthService>();
    final carService = context.read<CarService>();
    final rentalService = context.read<RentalService>();
    final repairService = context.read<RepairService>();
    final favoritesService = context.read<FavoritesService>();

    final success = await authService.loginWithGitHub();

    if (mounted) {
      if (success) {
        carService.setAuthToken(authService.token!);
        rentalService.setAuthToken(authService.token!);
        repairService.setAuthToken(authService.token!);
        favoritesService.setAuthToken(authService.token!);
        Navigator.pushNamed(context, AppConstants.homeRoute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authService.error ?? l10n.github_login_failed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    final l10n = AppLocalizations.of(context)!;
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reset_password),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.whats_your_email),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: l10n.email_address,
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.please_enter_email),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              if (!email.contains('@')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.please_enter_valid_email),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              // Generate a reset token (in production, this should come from your backend)
              final resetToken = DateTime.now().millisecondsSinceEpoch.toString();
              print('Generated reset token: $resetToken');

              // Send password reset email
              final success = await EmailService.sendPasswordResetEmail(
                email,
              );

              if (mounted) {
                Navigator.pop(context);
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.password_reset_sent),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.password_reset_failed),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.send),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppConstants.appTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.automotive_companion,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: l10n.username,
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.please_enter_username;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.please_enter_password;
                      }
                      if (value.length < AppConstants.minPasswordLength) {
                        return l10n.password_min_length(AppConstants.minPasswordLength);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Consumer<AuthService>(
                    builder: (context, authService, child) {
                      return ElevatedButton(
                        onPressed: authService.isLoading ? null : _handleLogin,
                        child: authService.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(l10n.login),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _handleForgotPassword,
                    child: Text(l10n.forgot_password),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.or,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Consumer<AuthService>(
                    builder: (context, authService, child) {
                      return OutlinedButton.icon(
                        onPressed: authService.isLoading
                            ? null
                            : _handleGitHubLogin,
                        icon: authService.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.code),
                        label: Text(l10n.continue_with_github),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppConstants.registerRoute),
                    child: const Text('Nog geen account? Registreren is gratis.'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
