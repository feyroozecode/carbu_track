import 'package:carbu_track/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../infrastructure/auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  final authService = AuthService();

  // login
  void login() async {
    final email = _emailController.text;
    final code = _codeController.text;
    if (!email.isEmpty || code.isEmpty) {
      try {
        await authService.signInWithEmailAndPassword(email, code);
      } catch (e) {
        //showErrorDialog(context, e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Une erreur est survenue. ${e.toString()}")));
      }
    }
    // Perform login logic
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Skip login button
              ElevatedButton(
                onPressed: () {
                  // Navigate to main app screen without login
                  // TODO: Replace with actual navigation
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text('Utiliser sans compte '.hardcoded),
              ),
              const SizedBox(height: 40),
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
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Mot de passe'.hardcoded,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: login,
                child: Text('Se connecter'.hardcoded),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navigate to sign up screen
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
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
    _codeController.dispose();
    super.dispose();
  }
}
