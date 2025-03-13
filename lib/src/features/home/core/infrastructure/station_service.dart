import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/station.dart';

class StationsService {
  List<Station> _stations = [];
  
  Future<List<Station>> loadStations() async {
    if (_stations.isNotEmpty) {
      return _stations;
    }
    
    try {
      final String response = await rootBundle.loadString('lib/common_data/main/stations.geojson');
      final data = await json.decode(response);
      
      final features = data['features'] as List;
      _stations = features
          .where((feature) => 
              feature['properties'] != null && 
              feature['properties']['amenity'] == 'fuel')
          .map<Station>((feature) => Station.fromGeoJson(feature))
          .toList();
      
      return _stations;
    } catch (e) {
      print('Error loading stations: $e');
      return [];
    }
  }
  
  List<Station> filterStationsByFuelType(String fuelType) {
    if (fuelType == 'All') {
      return _stations;
    }
    return _stations.where((station) => 
      station.fuelTypes.contains(fuelType)).toList();
  }
}