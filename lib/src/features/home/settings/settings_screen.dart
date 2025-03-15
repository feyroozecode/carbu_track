import 'package:carbu_track/src/features/auth/infrastructure/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/constants/app_colors.dart';
import 'providers/setting_provider.dart';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key});

  final authServoce = AuthService();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return ListView(
      children: [
        const SizedBox(height: 16),
        _buildSection(
          title: 'Préférences',
          children: [
            _buildSettingItem(
              icon: Icons.language,
              title: 'Langue',
              subtitle: settings.language,
              onTap: () => ref
                  .read(settingsProvider.notifier)
                  .updateLanguage('Français'),
            ),
            _buildSettingItem(
              icon: Icons.dark_mode,
              title: 'Thème',
              subtitle: settings.theme,
              onTap: () =>
                  ref.read(settingsProvider.notifier).updateTheme('Sombre'),
            ),
            _buildSettingItem(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: settings.notifications ? 'Activées' : 'Désactivées',
              onTap: () =>
                  ref.read(settingsProvider.notifier).toggleNotifications(),
            ),
          ],
        ),
        _buildSection(
          title: 'Carburant',
          children: [
            _buildSettingItem(
              icon: Icons.local_gas_station,
              title: 'Carburant préféré',
              subtitle: settings.preferredFuel,
              onTap: () => ref
                  .read(settingsProvider.notifier)
                  .updatePreferredFuel('Diesel'),
            ),
            _buildSettingItem(
              icon: Icons.euro,
              title: 'Devise',
              subtitle: settings.currency,
              onTap: () => ref
                  .read(settingsProvider.notifier)
                  .updateCurrency('F CFA (XOF)'),
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
              onTap: () {
                authServoce.signOut();
              },
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
              subtitle: settings.version,
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationIcon: Icon(Icons.local_gas_station),
                    applicationName: 'CarbuTrack',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© Mars 2025 AlfajerApps',
                    children: [
                      // developer par Ibrahim Ahmad contact suivants
                      const Card(
                          child: Column(
                        children: [
                          Row(
                            children: [
                              Text("Developpeur"),
                              Text("Ibrahim Ahmad")
                            ],
                          )
                        ],
                      ))
                    ]);
              },
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

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
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
