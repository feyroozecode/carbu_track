import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/constants/app_colors.dart';
import '../../core/domain/station.dart';
import '../../core/presentation/providers/stations_provider.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(stationsProvider);
    final favoriteStations = stations.where((station) => station.isFavorite).toList();
    
    if (favoriteStations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune station favorite',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez des stations à vos favoris\npour les retrouver ici',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteStations.length,
      itemBuilder: (context, index) {
        final station = favoriteStations[index];
        return _buildStationCard(context, station, ref);
      },
    );
  }
  
  Widget _buildStationCard(BuildContext context, Station station, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_gas_station,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
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
                        Text(
                          station.brand!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    ref.read(stationsProvider.notifier).removeFromFavorites(station.id);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (station.fuelTypes.isNotEmpty) ...[
              const Text(
                'Carburants disponibles:',
                style: TextStyle(
                  fontSize: 14,
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
                      fontSize: 12,
                    ),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showStationDetails(context, station);
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Détails'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = 'https://www.google.com/maps/dir/?api=1&destination=${station.latitude},${station.longitude}';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        debugPrint('Could not launch $url');
                      }
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text('Itinéraire'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showStationDetails(BuildContext context, Station station) {
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
                      Consumer(
                        builder: (context, ref, _) {
                          return IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 28,
                            ),
                            onPressed: () {
                              ref.read(stationsProvider.notifier).removeFromFavorites(station.id);
                              Navigator.pop(context);
                            },
                          );
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
                    'Carburants disponibles',
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
                    'Localisation',
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
                    onPressed: () async {
                      final url = 'https://www.google.com/maps/dir/?api=1&destination=${station.latitude},${station.longitude}';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        debugPrint('Could not launch $url');
                      }
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text('Obtenir l\'itinéraire'),
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
}