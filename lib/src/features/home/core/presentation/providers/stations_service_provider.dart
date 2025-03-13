


import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/stations_repository.dart';
import '../../domain/station.dart';

// Repository provider
final stationsRepositoryProvider = Provider<StationsRepository>((ref) {
  return StationsRepository();
});

// Loading state provider
final stationsLoadingProvider = StateProvider<bool>((ref) => false);

// All stations provider
final stationsProvider = FutureProvider<List<Station>>((ref) async {
  final repository = ref.read(stationsRepositoryProvider);
  ref.read(stationsLoadingProvider.notifier).state = true;
  
  try {
    final stations = await repository.loadStations();
    return stations;
  } finally {
    ref.read(stationsLoadingProvider.notifier).state = false;
  }
});

// Selected fuel type provider
final selectedFuelTypeProvider = StateProvider<String>((ref) => 'All');

// Filtered stations provider
final filteredStationsProvider = Provider<List<Station>>((ref) {
  final stationsAsyncValue = ref.watch(stationsProvider);
  final selectedFuelType = ref.watch(selectedFuelTypeProvider);
  final repository = ref.watch(stationsRepositoryProvider);
  
  return stationsAsyncValue.when(
    data: (stations) => repository.filterStationsByFuelType(stations, selectedFuelType),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Search results provider
final searchResultsProvider = Provider<List<Station>>((ref) {
  final filteredStations = ref.watch(filteredStationsProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final repository = ref.watch(stationsRepositoryProvider);
  
  if (searchQuery.isEmpty) {
    return filteredStations;
  }
  
  return repository.searchStations(filteredStations, searchQuery);
});