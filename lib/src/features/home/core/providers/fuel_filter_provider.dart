import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/station.dart';
import 'stations_provider.dart';

// Provider for selected fuel type
final selectedFuelTypeProvider = StateProvider<String>((ref) => 'All');

// Provider for available fuel types
final availableFuelTypesProvider = Provider<List<String>>((ref) {
  return [
    'All',
    'Diesel',
    'SP95',
    'SP98',
    'E10',
    'E85',
    'GPLc'
  ];
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