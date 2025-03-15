import 'package:carbu_track/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../infrastructure/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final authService = AuthService();

  // sign up
  void signUp() async {
    final email = _emailController.text;
    final code = _passwordController.text;
    final confirmCode = _confirmPasswordController.text;
    if (code != confirmCode) {
      // showErrorDialog(
      //     context, "Les mots de passe ne correspondent pas".hardcoded)
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text("Les mots de passe ne correspondent pas".hardcoded),
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
    if (email.isEmpty || code.isEmpty) {
      try {
        await authService.signUpWithEmailAndPassword(email, code);
      } catch (e) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content:
                Text("Une erreur s'est produite ${e.toString()}".hardcoded),
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
        // showErrorDialog(context, e.toString());
      }
    }
    // Perform login logic
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
      appBar: AppBar(
        title: Text('Creation de compte '.hardcoded),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Connexion'.hardcoded,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Email'.hardcoded,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Mot de passe'.hardcoded,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Confirmation de mot de passe'.hardcoded,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Se connecter'.hardcoded),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: signUp,
                child: Text("Pas encore de compte ? S'inscrire".hardcoded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
