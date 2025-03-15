import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/constants/app_colors.dart';
import '../../favorites/presentation/favorite_screen.dart';
import 'widgets/map_screen.dart';
import '../../settings/settings_screen.dart';
import 'widgets/notification_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedTab = 0;
  bool isFullScreen = false;

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      //const HomeWidget(),
      const MapScreen(),
      const FavoriteScreen(),
      const NotificationScreen(),
      SettingsScreen(),
    ];
  }

  // refresh screen

  List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[
    //BottomNavigationBarItem(label: "Accueil", icon: Icon(Icons.home)),
    const BottomNavigationBarItem(label: "Carte", icon: Icon(Icons.map)),
    const BottomNavigationBarItem(label: "Favoris", icon: Icon(Icons.favorite)),
    BottomNavigationBarItem(
      label: "Notifis",
      icon: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: const Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ),
    BottomNavigationBarItem(label: "Plus", icon: Icon(Icons.settings)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullScreen && selectedTab == 0
          ? null
          : AppBar(
              title: const Text('CarbuTrack',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  )),
              actions: [
                if (selectedTab == 0) // Show fullscreen toggle only for map
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                IconButton(
                  icon: Icon(
                      isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                  onPressed: () {
                    setState(() {
                      isFullScreen = !isFullScreen;
                    });
                  },
                ),
                // Add contribute button
                IconButton(
                  icon: Icon(Icons.volunteer_activism),
                  tooltip: 'Contribuer',
                  onPressed: () {
                    // Show contribute dialog or navigate to contribute screen
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Contribuer à CarbuTrack'),
                          content: Text(
                              'Vous pouvez supporter le projet en contribuant à son développement.'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: Text('Contribuer '),
                              onPressed: () {
                                // Implement contribution logic here
                                // make an dialog to show how you can help the project by giving a donation ou en aident a a jotuter des staitions etc.. envoi via STA(Envoi d'argent, Transfert d'argent, etc.)
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Contribuer à CarbuTrack'),
                                        content: Text(
                                            'Vous pouvez supporter le projet en contribuant à son développement.'),
                                        actions: [
                                          TextButton(
                                            child: Text('Annuler'),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          TextButton(
                                            child:
                                                Text('Cliquer ici Contribuer '),
                                            onPressed: () async {
                                              await launchUrl(Uri.parse(
                                                  'https://wa.me/+22799463594?text=BonjourjaiinstallercarbuTrack,_je_vais_aidez_le_projet '));
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
      backgroundColor: AppColors.background,
      body: screens[selectedTab],
      bottomNavigationBar: isFullScreen && selectedTab == 0
          ? null
          : BottomNavigationBar(
              elevation: 10,
              currentIndex: selectedTab,
              selectedFontSize: 12,
              iconSize: 24,
              unselectedFontSize: 10,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              selectedIconTheme: const IconThemeData(size: 20),
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              onTap: (int index) {
                setState(() {
                  selectedTab = index;
                  // Exit fullscreen mode when switching to non-map tab
                  if (isFullScreen && index != 0) {
                    isFullScreen = false;
                  }
                });
              },
              items: items,
            ),
      floatingActionButton: isFullScreen && selectedTab == 0
          ? Padding(
              padding: const EdgeInsets.only(bottom: 64.0),
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.fullscreen_exit,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    isFullScreen = false;
                  });
                },
              ),
            )
          : null,
    );
  }
}
