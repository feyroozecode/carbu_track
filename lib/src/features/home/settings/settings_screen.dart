import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/constants/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        _buildSection(
          title: 'Préférences',
          children: [
            _buildSettingItem(
              icon: Icons.language,
              title: 'Langue',
              subtitle: 'Français',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.dark_mode,
              title: 'Thème',
              subtitle: 'Clair',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Activées',
              onTap: () {},
            ),
          ],
        ),
        _buildSection(
          title: 'Carburant',
          children: [
            _buildSettingItem(
              icon: Icons.local_gas_station,
              title: 'Carburant préféré',
              subtitle: 'Diesel',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.euro,
              title: 'Devise',
              subtitle: 'F CFA (XOF)',
              onTap: () {},
            ),
          ],
        ),
        _buildSection(
          title: 'Compte',
          children: [
            _buildSettingItem(
              icon: Icons.person,
              title: 'Profil',
              subtitle: 'Modifier vos informations',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.security,
              title: 'Confidentialité',
              subtitle: 'Gérer vos données',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.logout,
              title: 'Déconnexion',
              subtitle: '',
              onTap: () {},
              textColor: Colors.red,
            ),
          ],
        ),
        _buildSection(
          title: 'À propos',
          children: [
            _buildSettingItem(
              icon: Icons.info,
              title: 'Version',
              subtitle: '1.0.0',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.help,
              title: 'Aide',
              subtitle: 'FAQ et support',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.policy,
              title: 'Conditions d\'utilisation',
              subtitle: '',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            '© 2023 CarbuTrack',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}