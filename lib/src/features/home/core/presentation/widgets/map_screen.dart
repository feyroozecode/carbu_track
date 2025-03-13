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

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  final List<String> _fuelTypes = [
    'All',
    'Diesel',
    'SP95',
    'SP98',
    'E10',
    'E85',
    'GPLc'
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    
    // Load stations when the widget initializes
    Future.microtask(() {
      ref.read(stationsLoadingProvider.notifier).state = true;
      ref.read(stationsProvider.notifier).loadStations().then((_) {
        ref.read(stationsLoadingProvider.notifier).state = false;
      });
    });
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      ref.read(userLocationProvider.notifier).updateLocation(
        LatLng(position.latitude, position.longitude)
      );
      
      _mapController.move(
        LatLng(position.latitude, position.longitude), 
        13.0
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  String euroToCFA(double price) {
    return '${(price * 655).toStringAsFixed(2)} FCFA';
  }

  void _showStationDetails(Station station) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              station.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (station.brand != null) ...[
              const SizedBox(height: 4),
              Text('Societe: ${station.brand}'),
            ],
            const SizedBox(height: 8),
            Text('Disponibilite d\'essence: ${station.fuelTypes.join(', ')}'),
            const SizedBox(height: 8),
            const Text('Prices:'),
            ...station.prices.entries.map(
              (entry) => Text('${entry.key}: ${euroToCFA(entry.value)} CFA'),
            ),
            if (station.hasCompressedAir) ...[
              const SizedBox(height: 8),
              const Text('✓ Air compresse disponible'),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    // Navigate to directions
                    Navigator.pop(context);
                    final url = 'https://www.google.com/maps/dir/?api=1&destination=${station.latitude},${station.longitude}';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await canLaunchUrl(Uri.parse(url));
                    } else {
                      debugPrint('Could not launch $url');
                    }

                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Directions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Save as favorite
                    if (station.isFavorite) {
                      ref.read(stationsProvider.notifier).removeFromFavorites(station.id);
                    } else {
                      ref.read(stationsProvider.notifier).addToFavorites(station.id);
                    }
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    station.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(station.isFavorite ? 'Remove' : 'Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: station.isFavorite ? AppColors.primary : Colors.white,
                    foregroundColor: station.isFavorite ? Colors.white : AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(userLocationProvider);
    final stations = ref.watch(filteredStationsProvider);
    final selectedFuelType = ref.watch(selectedFuelTypeProvider);
    final isLoading = ref.watch(stationsLoadingProvider);
    
    // Create markers from stations
    final List<Marker> markers = stations.map((station) {
      return Marker(
        width: 40.0,
        height: 40.0,
        point: LatLng(station.latitude, station.longitude),
        child: GestureDetector(
          onTap: () => _showStationDetails(station),
          child: Icon(
            Icons.local_gas_station,
            color: station.isFavorite ? Colors.red : AppColors.primary,
            size: 30,
          ),
        ),
      );
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              // center: userLocation,
              // zoom: 13.0,
              initialZoom: 13.0,
              maxZoom: 18.0,
              minZoom: 6.0,
              onTap: (_, __) => FocusScope.of(context).unfocus(),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.carbutrack.app',
              ),
              MarkerClusterLayerWidget(
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
            ],
          ),
          // Fuel type filter
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _fuelTypes.map((fuelType) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(fuelType),
                          selected: selectedFuelType == fuelType,
                          onSelected: (selected) {
                            if (selected) {
                              ref.read(selectedFuelTypeProvider.notifier).state = fuelType;
                            }
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: selectedFuelType == fuelType
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          // Loading indicator
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          // Station count indicator
          Positioned(
            bottom: 80,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  '${stations.length} stations',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
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