import 'package:autopaleis/shared/services/favorites_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              content: Text(authService.error ?? 'Login failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleGitHubLogin() async {
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
            content: Text(authService.error ?? 'GitHub login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wachtwoord Opnieuw Instellen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Wat is je e-mailadres? Dan zenden we je binnen enkele minuten een linkje om een nieuw wachtwoord in te stellen.'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mailadres',
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
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Voer uw e-mailadres in'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              if (!email.contains('@')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Voer een geldig e-mailadres in'),
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
                    const SnackBar(
                      content: Text('E-mail voor wachtwoordherstel verzonden! Controleer uw inbox.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Het verzenden van de herstel-e-mail is mislukt. Probeer het opnieuw.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Verzenden'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    'Your automotive companion',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                        return 'Please enter your password';
                      }
                      if (value.length < AppConstants.minPasswordLength) {
                        return 'Password must be at least ${AppConstants.minPasswordLength} characters';
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
                            : const Text('Login'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _handleForgotPassword,
                    child: const Text('Forgot Password?'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
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
                        label: const Text('Continue with GitHub'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      );
                    },
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
