import 'package:carbu_track/src/common/constants/app_colors.dart';
import 'package:carbu_track/src/features/auth/infrastructure/auth_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 50,
                child: Text(_authService.getCurrentEmail())),
            const SizedBox(height: 20),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            _buildInfoCard(
              icon: Icons.phone,
              title: 'Phone',
              subtitle: '+1 234 567 890',
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              icon: Icons.location_on,
              title: 'Location',
              subtitle: 'New York, USA',
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              icon: Icons.calendar_today,
              title: 'Member Since',
              subtitle: 'January 2023',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle edit profile
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
