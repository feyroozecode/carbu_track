import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/station.dart';
import '../providers/location_provider.dart';

// Provider for loading state
final stationsLoadingProvider = StateProvider<bool>((ref) => false);

// Provider for the selected fuel type
final selectedFuelTypeProvider = StateProvider<String>((ref) => 'All');

// Provider for the list of stations
final stationsProvider = StateNotifierProvider<StationsNotifier, List<Station>>((ref) {
  return StationsNotifier();  
});

// Provider for filtered stations based on selected fuel type
final filteredStationsProvider = Provider<List<Station>>((ref) {
  final stations = ref.watch(stationsProvider);
  final selectedFuelType = ref.watch(selectedFuelTypeProvider);
  
  if (selectedFuelType == 'All') {
    return stations;
  }
  
  return stations.where((station) => 
    station.fuelTypes.contains(selectedFuelType)).toList();
});

// Provider for the nearest station to user location
final nearestStationProvider = Provider<Station?>((ref) {
  final stations = ref.watch(filteredStationsProvider);
  final userLocation = ref.watch(userLocationProvider);
  
  if (userLocation == null || stations.isEmpty) {
    return null;
  }
  
  // Calculate distance to each station and find the nearest
  final distance = Distance();
  Station nearestStation = stations.first;
  double shortestDistance = distance.as(
    LengthUnit.Kilometer,
    userLocation,
    LatLng(nearestStation.latitude, nearestStation.longitude)
  );
  
  for (final station in stations) {
    final stationLocation = LatLng(station.latitude, station.longitude);
    final distanceToStation = distance.as(
      LengthUnit.Kilometer,
      userLocation,
      stationLocation
    );
    
    if (distanceToStation < shortestDistance) {
      shortestDistance = distanceToStation;
      nearestStation = station;
    }
  }
  
  return nearestStation;
});

// Provider for the distance to the nearest station
final distanceToNearestStationProvider = Provider<double?>((ref) {
  final nearestStation = ref.watch(nearestStationProvider);
  final userLocation = ref.watch(userLocationProvider);
  
  if (nearestStation == null || userLocation == null) {
    return null;
  }
  
  final distance = Distance();
  return distance.as(
    LengthUnit.Kilometer,
    userLocation,
    LatLng(nearestStation.latitude, nearestStation.longitude)
  );
});

class StationsNotifier extends StateNotifier<List<Station>> {
  StationsNotifier() : super([]);

  Future<void> loadStations() async {
    try {
      // Set loading state
      // Load the GeoJSON file
      final String response = await rootBundle.loadString('lib/common_data/main/stations.geojson');
      final data = await json.decode(response);
      
      // Extract features and convert to Station objects
      final features = data['features'] as List;
      final stations = features
          .where((feature) => 
              feature['properties'] != null && 
              feature['properties']['amenity'] == 'fuel')
          .map<Station>((feature) => Station.fromGeoJson(feature))
          .toList();
      
      // Update state with loaded stations
      state = stations;
    } catch (e) {
      print('Error loading stations: $e');
      // In case of error, set empty list
      state = [];
    }
  }
  
  // Add a station to favorites
  void addToFavorites(String stationId) {
    state = state.map((station) {
      if (station.id == stationId) {
        return station.copyWith(isFavorite: true);
      }
      return station;
    }).toList();
  }
  
  // Remove a station from favorites
  void removeFromFavorites(String stationId) {
    state = state.map((station) {
      if (station.id == stationId) {
        return station.copyWith(isFavorite: false);
      }
      return station;
    }).toList();
  }
}