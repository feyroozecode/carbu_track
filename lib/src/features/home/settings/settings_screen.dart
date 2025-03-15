import 'package:carbu_track/src/common/constants/app_size.dart';
import 'package:carbu_track/src/features/auth/infrastructure/auth_service.dart';
import 'package:carbu_track/src/features/splash/presentation/splash_screen.dart';
import 'package:carbu_track/src/router/app_router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
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
            authServoce.getSession() != null
                ? _buildProfileItem(
                    icon: Icons.person,
                    userName: authServoce.getCurrentEmail(),
                    subtitle: authServoce.getCurrentEmail(),
                    onTap: () {})
                : Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Utilsateur Invité, veillez vous connecter pour accéder à vos données",
                          style: TextStyle(color: Colors.red),
                        ),
                        gapH16,
                        ElevatedButton(
                            onPressed: () {
                              context.pushReplacement(AppRoutes.gate.path);
                            },
                            child: Text("Se connecter"))
                      ],
                    )),
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
            // _buildSettingItem(
            //   icon: Icons.notifications,
            //   title: 'Notifications',
            //   subtitle: settings.notifications ? 'Activées' : 'Désactivées',
            //   onTap: () =>
            //       ref.read(settingsProvider.notifier).toggleNotifications(),
            // ),
          ],
        ),
        // _buildSection(
        //   title: 'Carburant',
        //   children: [
        //     _buildSettingItem(
        //       icon: Icons.local_gas_station,
        //       title: 'Carburant préféré',
        //       subtitle: settings.preferredFuel,
        //       onTap: () => ref
        //           .read(settingsProvider.notifier)
        //           .updatePreferredFuel('Diesel'),
        //     ),
        //     _buildSettingItem(
        //       icon: Icons.euro,
        //       title: 'Devise',
        //       subtitle: settings.currency,
        //       onTap: () => ref
        //           .read(settingsProvider.notifier)
        //           .updateCurrency('F CFA (XOF)'),
        //     ),
        //   ],
        // ),
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
            // detail of developer
            _buildSettingItem(
              icon: Icons.info,
              title: 'Développeur',
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
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Card(
                              margin: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text("Par"),
                                  gapH12,
                                  Text("Ibrahim Ahmad"),
                                  gapH20,
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          'Clique ici Whatsapp (+227 99463594) ',
                                      style: TextStyle(color: Colors.green),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // do something
                                          launchUrl(Uri.parse(
                                              'https://wa.me/+22799463594?text=Bonjour jai installer carbuTrack'));
                                        },
                                    ),
                                  ),
                                  gapH16,
                                  RichText(
                                    text: TextSpan(
                                      text: 'Contact Linkedin ',
                                      style: TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // do something
                                          launchUrl(Uri.parse(
                                              'https://www.linkedin.com/in/feyroozcode/'));
                                        },
                                    ),
                                  )
                                ],
                              )))
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

  // build Profile Item
  Widget _buildProfileItem({
    required IconData icon,
    required String userName,
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
        userName,
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
