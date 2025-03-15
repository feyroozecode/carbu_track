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
    if (email.isNotEmpty || code.isNotEmpty) {
      try {
        await authService.signUpWithEmailAndPassword(email, code).then(
          (value) {
            Navigator.pop(context);
          },
        );
        // show dialogCicularProgress
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Une erreur s'est produite ${e.toString()}".hardcoded),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Creation de conpte '.hardcoded,
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
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe'.hardcoded,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmation de mot de passe'.hardcoded,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: signUp,
              child: Text('Creer un compte '.hardcoded),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("J'ai un  compte ? Se connecter".hardcoded),
            ),
          ],
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
