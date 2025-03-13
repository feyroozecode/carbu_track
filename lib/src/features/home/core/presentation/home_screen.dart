import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/constants/app_colors.dart';
import 'widgets/map_screen.dart';
import '../../settings/settings_screen.dart';

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
      //const ProfileScreen(),
      const SettingsScreen(),
    ];
  }

  List<BottomNavigationBarItem> items = const <BottomNavigationBarItem>[
    //BottomNavigationBarItem(label: "Accueil", icon: Icon(Icons.home)),
    BottomNavigationBarItem(label: "Carte", icon: Icon(Icons.map)),
    //BottomNavigationBarItem(label: "Profil", icon: Icon(Icons.person)),
    BottomNavigationBarItem(label: "Plus", icon: Icon(Icons.settings)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullScreen && selectedTab == 1 
          ? null 
          : AppBar(
              title: const Text('CarbuTrack',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  )),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // Handle notification button press
                  },
                ),
                if (selectedTab == 1) // Only show fullscreen toggle for map
                  IconButton(
                    icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                    onPressed: () {
                      setState(() {
                        isFullScreen = !isFullScreen;
                      });
                    },
                  ),
              ],
            ),
      backgroundColor: AppColors.background,
      body: screens[selectedTab],
      bottomNavigationBar: isFullScreen && selectedTab == 1
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
                  // Exit fullscreen mode when switching tabs
                  if (isFullScreen && index != 1) {
                    isFullScreen = false;
                  }
                });
              },
              items: items,
            ),
      floatingActionButton: isFullScreen && selectedTab == 1
          ? FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.fullscreen_exit,
                color: AppColors.primary,
              ),
              onPressed: () {
                setState(() {
                  isFullScreen = false;
                });
              },
            )
          : null,
    );
  }
}
