import 'package:carbu_track/src/features/home/core/presentation/home_screen.dart';
import 'package:carbu_track/src/features/home/settings/providers/setting_provider.dart';
import 'package:carbu_track/src/features/splash/presentation/splash_screen.dart';
import 'package:carbu_track/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_router.dart';
import '../infrastructure/auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  final authService = AuthService();

  // login
  void login() async {
    final email = _emailController.text;
    final code = _codeController.text;
    if (email.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Veuillez remplir tous les champs".hardcoded)));
      return;
    }

    try {
      // Try to sign in first
      await authService.signInWithEmailAndPassword(email, code);
      // If successful, navigate to home
      //context.pushReplacement(AppRoutes.home.path);
    } catch (e) {
      // If sign in fails, try to create a new account
      try {
        await authService.signUpWithEmailAndPassword(email, code).then((r) {
          // if user created
          if (r.session != null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Compte créé avec succès".hardcoded)));
          }
        });
        // If account creation is successful, navigate to home
      } catch (signUpError) {
        // If both sign in and sign up fail, show error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Une erreur est survenue. ${signUpError.toString()}")));
      }
    }
  }

  // sign up
  void signUp() async {
    final email = _emailController.text;
    final code = _codeController.text;
    if (email.isEmpty || code.isEmpty) {
      try {
        await authService.signUpWithEmailAndPassword(email, code);
      } catch (e) {
        showErrorDialog(context, e.toString());
      }
    }
    // Perform login logic
  }

  // navigateToHome
  void navigateToHome() {
    // Navigate to main app screen without login
    // TODO: Replace with actual navigation with go router

    context.pushReplacement(
      AppRoutes.home.path,
    );
  }

  // showErrorDialog
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erreur'.hardcoded),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'.hardcoded),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Skip login button
            ElevatedButton(
              onPressed: navigateToHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                'Utiliser sans compte(Utilsiateur invité) '.hardcoded,
                style: TextStyle(
                  color: ref.watch(settingsProvider).theme == 'dark'
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Connexion'.hardcoded,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email'.hardcoded,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe'.hardcoded,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: login,
              child: Text('Se connecter'.hardcoded),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Navigate to sign up screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupScreen()));
              },
              child: Text("Pas encore de compte ? S'inscrire".hardcoded),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}
