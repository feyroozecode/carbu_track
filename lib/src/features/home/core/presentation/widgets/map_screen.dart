import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/constants/app_colors.dart';
import '../../domain/station.dart';
import '../providers/location_provider.dart';
import '../providers/stations_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  bool _showOnboarding = false;
  bool _showNearestStationSheet = false;
  bool _isSatelliteView = true;
  late AnimationController _routeAnimationController;
  late Animation<double> _routeAnimation;

  // Loading state trackers for different features
  bool _isMapLoading = true;
  bool _isStationsLoading = true;
  bool _isLocationLoading = true;
  bool _isRouteCalculating = false;

  // Animation controllers for smooth transitions
  late AnimationController _mapFadeController;
  late AnimationController _stationsFadeController;
  late AnimationController _locationFadeController;

  final List<String> _fuelTypes = [
    'Tout',
    'SP95',
    'SP98',
    'Gazole',
    'E10',
    'E85',
    'GPL'
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers for smooth loading transitions
    _mapFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _stationsFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _locationFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Initialize route animation controller
    _routeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _routeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _routeAnimationController, curve: Curves.easeInOut));

    // Start the loading sequence
    //_startLoadingSequence();
  }

  void _startLoadingSequence() async {
    // Step 1: Load the map
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isMapLoading = false;
      });
      _mapFadeController.forward();

      // Step 2: Request location permission after map is loaded
      _requestLocationPermission();
    });

    // Step 3: Load stations data
    ref.read(stationsLoadingProvider.notifier).state = true;
    ref.read(stationsProvider.notifier).loadStations().then((_) {
      setState(() {
        _isStationsLoading = false;
      });
      ref.read(stationsLoadingProvider.notifier).state = false;
      _stationsFadeController.forward();

      // Step 4: Show nearest station if location is already available
      if (!_isLocationLoading) {
        _showNearestStation();
      }
    });
  }

  @override
  void dispose() {
    _routeAnimationController.dispose();
    _mapFadeController.dispose();
    _stationsFadeController.dispose();
    _locationFadeController.dispose();
    super.dispose();
  }

  void _showNearestStation() {
    final userLocation = ref.read(userLocationProvider);
    final nearestStation = ref.read(nearestStationProvider);

    if (userLocation != null && nearestStation != null) {
      setState(() {
        _isRouteCalculating = true;
      });

      // Simulate route calculation time
      Future.delayed(const Duration(milliseconds: 500), () {
        // Start route animation
        _routeAnimationController.reset();
        _routeAnimationController.forward();

        setState(() {
          _showNearestStationSheet = true;
          _isRouteCalculating = false;
        });
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else if (status.isDenied) {
      // Show dialog explaining why we need location
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location Permission'),
            content:
                const Text('We need your location to show nearby gas stations. '
                    'Please grant location permission in app settings.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }

      setState(() {
        _isLocationLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = LatLng(position.latitude, position.longitude);
      ref.read(userLocationProvider.notifier).updateLocation(location);

      // Center map on user location
      _mapController.move(location, 15.0);

      setState(() {
        _isLocationLoading = false;
      });
      _locationFadeController.forward();

      // Check for nearest station if stations are already loaded
      if (!_isStationsLoading) {
        _showNearestStation();
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      setState(() {
        _isLocationLoading = false;
      });
    }
  }

  void _toggleOnboarding() {
    setState(() {
      _showOnboarding = !_showOnboarding;
    });
  }

  Future<void> _openMaps(double lat, double lng) async {
    final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    if (await canLaunchUrl(
      Uri.https(
        'www.google.com',
        '/maps/search',
        {'api': '1', 'query': '$lat,$lng'},
      ),
    )) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint('Could not launch $url');
    }
  }

  void _showStationDetails(Station station) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Station name and favorite button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          station.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          station.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: station.isFavorite ? Colors.red : null,
                          size: 28,
                        ),
                        onPressed: () {
                          if (station.isFavorite) {
                            ref
                                .read(stationsProvider.notifier)
                                .removeFromFavorites(station.id);
                          } else {
                            ref
                                .read(stationsProvider.notifier)
                                .addToFavorites(station.id);
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),

                  // Brand
                  if (station.brand != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      station.brand!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Fuel types
                  const Text(
                    'Available Fuels',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: station.fuelTypes.map((fuel) {
                      return Chip(
                        label: Text(fuel),
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        labelStyle: const TextStyle(
                          color: AppColors.primary,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Location
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Latitude: ${station.latitude.toStringAsFixed(6)}\n'
                    'Longitude: ${station.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Actions
                  ElevatedButton.icon(
                    onPressed: () async => _openMaps(
                      station.latitude,
                      station.longitude,
                    ),
                    icon: const Icon(Icons.directions),
                    label: const Text('Get Directions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOnboardingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bienvenue sur CarbuTrack',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Trouvez les stations-service près de chez vous',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildOnboardingStep(
                icon: Icons.local_gas_station,
                title: 'Trouvez des stations',
                description:
                    'Visualisez toutes les stations-service sur la carte',
              ),
              const SizedBox(height: 16),
              _buildOnboardingStep(
                icon: Icons.favorite,
                title: 'Ajoutez aux favoris',
                description: 'Enregistrez vos stations préférées',
              ),
              const SizedBox(height: 16),
              _buildOnboardingStep(
                icon: Icons.filter_alt,
                title: 'Filtrez par carburant',
                description:
                    'Trouvez les stations qui proposent votre carburant',
              ),
              const SizedBox(height: 16),
              _buildOnboardingStep(
                icon: Icons.layers,
                title: 'Changez de vue',
                description: 'Basculez entre la carte et la vue satellite',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _toggleOnboarding,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Commencer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildLoadingStep(String stepName, bool isCompleted) {
  //   return Row(
  //     children: [
  //       Container(
  //         width: 24,
  //         height: 24,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: isCompleted ? Colors.green : Colors.grey[300],
  //         ),
  //         child: Center(
  //           child: isCompleted
  //               ? const Icon(
  //                   Icons.check,
  //                   color: Colors.white,
  //                   size: 16,
  //                 )
  //               : SizedBox(
  //                   width: 12,
  //                   height: 12,
  //                   child: CircularProgressIndicator(
  //                     strokeWidth: 2,
  //                     valueColor: AlwaysStoppedAnimation<Color>(
  //                       AppColors.primary,
  //                     ),
  //                   ),
  //                 ),
  //         ),
  //       ),
  //       const SizedBox(width: 12),
  //       Text(
  //         stepName,
  //         style: TextStyle(
  //           fontSize: 14,
  //           color: isCompleted ? Colors.green : Colors.grey[700],
  //           fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(userLocationProvider);
    final stations = ref.watch(filteredStationsProvider);
    final nearestStation = ref.watch(nearestStationProvider);
    final selectedFuelType = ref.watch(selectedFuelTypeProvider);
    final isLoading = ref.watch(stationsLoadingProvider);

    // Create markers from stations
    final List<Marker> markers = stations.map((station) {
      final isNearest =
          nearestStation != null && station.id == nearestStation.id;

      return Marker(
        width: 40.0,
        height: 40.0,
        point: LatLng(station.latitude, station.longitude),
        child: GestureDetector(
          onTap: () => _showStationDetails(station),
          child: Icon(
            Icons.local_gas_station,
            color: isNearest
                ? Colors.green
                : (station.isFavorite ? Colors.red : AppColors.primary),
            size: isNearest ? 35 : 30,
          ),
        ),
      );
    }).toList();

    // Add user location marker if available
    if (userLocation != null) {
      markers.add(
        Marker(
          width: 60.0,
          height: 60.0,
          point: userLocation,
          child: GestureDetector(
            onTap: () {
              _mapController.move(userLocation, 15.0);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated pulsing circle
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Container(
                      width: 50.0 * value,
                      height: 50.0 * value,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3 * (1 - value)),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                  onEnd: () {
                    // Rebuild to restart the animation
                    setState(() {});
                  },
                ),
                // Inner blue circle
                Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                // User icon
                const Icon(
                  Icons.person_pin_circle,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Map with fade-in animation
          FadeTransition(
            opacity: _mapFadeController,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialZoom: 13.0,
                maxZoom: 18.0,
                minZoom: 6.0,
                onTap: (_, __) => FocusScope.of(context).unfocus(),
              ),
              children: [
                TileLayer(
                  urlTemplate: _isSatelliteView
                      ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                      : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.carbutrack.app',
                ),

                // Draw route line to nearest station with animation
                if (userLocation != null && nearestStation != null)
                  AnimatedBuilder(
                    animation: _routeAnimation,
                    builder: (context, child) {
                      return PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [
                              userLocation,
                              LatLng(
                                  userLocation.latitude +
                                      (nearestStation.latitude -
                                              userLocation.latitude) *
                                          _routeAnimation.value,
                                  userLocation.longitude +
                                      (nearestStation.longitude -
                                              userLocation.longitude) *
                                          _routeAnimation.value),
                            ],
                            strokeWidth: 4.0,
                            color: Colors.blue,
                            //isDotted: true,
                          ),
                        ],
                      );
                    },
                  ),

                // Direction arrow with animation
                if (userLocation != null && nearestStation != null)
                  AnimatedBuilder(
                    animation: _routeAnimation,
                    builder: (context, child) {
                      // Calculate midpoint for arrow
                      final midLat = userLocation.latitude +
                          (nearestStation.latitude - userLocation.latitude) *
                              0.5;
                      final midLng = userLocation.longitude +
                          (nearestStation.longitude - userLocation.longitude) *
                              0.5;

                      // Calculate angle for arrow
                      final angle = atan2(
                          nearestStation.latitude - userLocation.latitude,
                          nearestStation.longitude - userLocation.longitude);

                      return MarkerLayer(
                        markers: [
                          Marker(
                            width: 30.0,
                            height: 30.0,
                            point: LatLng(midLat, midLng),
                            child: Transform.rotate(
                              angle: angle,
                              child: Opacity(
                                opacity: _routeAnimation.value,
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                // Stations markers with fade-in animation
                FadeTransition(
                  opacity: _stationsFadeController,
                  child: MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 45,
                      size: const Size(40, 40),
                      markers: markers,
                      builder: (context, markers) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.primary,
                          ),
                          child: Center(
                            child: Text(
                              markers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Feature-based loading indicators
          // if (_isMapLoading ||
          //     _isStationsLoading ||
          //     _isLocationLoading ||
          //     _isRouteCalculating)
          //   Positioned.fill(
          //     child: Container(
          //       color: Colors.black.withOpacity(0.3),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const CircularProgressIndicator(
          //             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //           ),
          //           const SizedBox(height: 24),
          //           Container(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 24, vertical: 16),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Text(
          //                   'Chargement de CarbuTrack',
          //                   style: TextStyle(
          //                     fontSize: 18,
          //                     fontWeight: FontWeight.bold,
          //                     color: AppColors.primary,
          //                   ),
          //                 ),
          //                 const SizedBox(height: 16),
          //                 _buildLoadingStep(
          //                   'Chargement de la carte',
          //                   !_isMapLoading,
          //                 ),
          //                 const SizedBox(height: 8),
          //                 _buildLoadingStep(
          //                   'Recherche des stations',
          //                   !_isStationsLoading,
          //                 ),
          //                 const SizedBox(height: 8),
          //                 _buildLoadingStep(
          //                   'Localisation en cours',
          //                   !_isLocationLoading,
          //                 ),
          //                 if (_isRouteCalculating) ...[
          //                   const SizedBox(height: 8),
          //                   _buildLoadingStep(
          //                     'Calcul de l\'itinéraire',
          //                     false,
          //                   ),
          //                 ],
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),

          // Fuel type filter
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _fuelTypes.length,
                itemBuilder: (context, index) {
                  final fuelType = _fuelTypes[index];
                  final isSelected =
                      selectedFuelType == (index == 0 ? 'All' : fuelType);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(fuelType),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(selectedFuelTypeProvider.notifier).state =
                              index == 0 ? 'All' : fuelType;
                        }
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Map controls
          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          final currentZoom = _mapController.camera.zoom;
                          _mapController.move(
                              _mapController.camera.center, currentZoom + 1.0);
                        },
                        tooltip: 'Zoom in',
                      ),
                      const Divider(height: 1),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          final currentZoom = _mapController.camera.zoom;
                          _mapController.move(
                              _mapController.camera.center, currentZoom - 1.0);
                        },
                        tooltip: 'Zoom out',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                        _isSatelliteView ? Icons.map : Icons.satellite_alt),
                    onPressed: () {
                      setState(() {
                        _isSatelliteView = !_isSatelliteView;
                      });
                    },
                    tooltip: _isSatelliteView
                        ? 'Switch to map view'
                        : 'Switch to satellite view',
                  ),
                ),
              ],
            ),
          ),

          // Loading indicator
          if (isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Nearest station bottom sheet
          if (_showNearestStationSheet &&
              nearestStation != null &&
              userLocation != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _showStationDetails(nearestStation),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Handle
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Station la plus proche',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _showNearestStationSheet = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      // Direction indicator
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.brown.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: AppColors.primary,
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 2,
                                    color: Colors.grey[300],
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      5,
                                      (index) => Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.local_gas_station,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Station details
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nearestStation.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (nearestStation.brand != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                nearestStation.brand!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Text(
                              'Carburants: ${nearestStation.fuelTypes.join(", ")}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Consumer(
                              builder: (context, ref, _) {
                                final distance =
                                    ref.watch(distanceToNearestStationProvider);
                                return Text(
                                  'Distance: ${distance != null ? "${distance.toStringAsFixed(2)} km" : "Calcul en cours..."}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      _openMaps(nearestStation.latitude,
                                          nearestStation.longitude);
                                    },
                                    icon: const Icon(Icons.directions),
                                    label: const Text('Itinéraire'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (nearestStation.isFavorite) {
                                        ref
                                            .read(stationsProvider.notifier)
                                            .removeFromFavorites(
                                                nearestStation.id);
                                      } else {
                                        ref
                                            .read(stationsProvider.notifier)
                                            .addToFavorites(nearestStation.id);
                                      }
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      nearestStation.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                    ),
                                    label: Text(nearestStation.isFavorite
                                        ? 'Retirer'
                                        : 'Favoris'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: nearestStation.isFavorite
                                          ? Colors.red
                                          : Colors.white,
                                      foregroundColor: nearestStation.isFavorite
                                          ? Colors.white
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Show onboarding overlay if enabled
          if (_showOnboarding) _buildOnboardingOverlay(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
