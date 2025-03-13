import 'dart:convert';
import 'package:carbu_track/src/common/constants/api_keys.template.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../domain/station.dart';

class StationsRepository {
  // URL to your GeoJSON file hosted on private GitHub repo
  static const String _remoteGeoJsonUrl = 
    'https://api.github.com/repos/feyroozecode/geodata-niamey/niamey_stations.geojson';
  
  // Local fallback path
  static const String _localGeoJsonPath = 'lib/common_data/main/stations.geojson';
  
  Future<List<Station>> loadStations() async {
    try {
      // First try to fetch from remote source with authentication
      final response = await http.get(
        Uri.parse(_remoteGeoJsonUrl),
        headers: {
          'Authorization': 'token ${ApiKeys.githubToken}',
          'Accept': 'application/vnd.github.v3.raw',
        },
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        return _parseStationsFromJson(response.body);
      } else {
        print('Failed to load remote data: ${response.statusCode}');
        return _loadLocalStations();
      }
    } catch (e) {
      print('Error fetching remote stations: $e');
      return _loadLocalStations();
    }
  }
  
  Future<List<Station>> _loadLocalStations() async {
    try {
      final String response = await rootBundle.loadString(_localGeoJsonPath);
      return _parseStationsFromJson(response);
    } catch (e) {
      print('Error loading local stations: $e');
      return [];
    }
  }
  
  List<Station> _parseStationsFromJson(String jsonString) {
    final data = json.decode(jsonString);
    final features = data['features'] as List;
    
    return features
        .where((feature) => 
            feature['properties'] != null && 
            feature['properties']['amenity'] == 'fuel')
        .map<Station>((feature) => Station.fromGeoJson(feature))
        .toList();
  }

  /// Filters stations by fuel type
  /// Returns a list of stations that offer the specified fuel type
  List<Station> filterStationsByFuelType(List<Station> stations, String fuelType) {
    return stations.where((station) => 
      station.fuelTypes.contains(fuelType.toLowerCase())
    ).toList();
  }
  
  /// Searches stations by name or address
  /// Returns a list of stations that match the search query
  List<Station> searchStations(List<Station> stations, String query) {
    if (query.isEmpty) return stations;
    
    final searchTerm = query.toLowerCase();
    
    return stations.where((station) {
      final name = station.name.toLowerCase();
      
      // Check if any address component contains the search term
      final addressMatch = station.address.values.any(
        (value) => value.toLowerCase().contains(searchTerm)
      );
      
      // Check if brand contains the search term
      final brandMatch = station.brand?.toLowerCase().contains(searchTerm) ?? false;
      
      return name.contains(searchTerm) || 
             addressMatch ||
             brandMatch;
    }).toList();
  }
  


}