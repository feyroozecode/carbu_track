import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'station.freezed.dart';
part 'station.g.dart';

@freezed
class Station with _$Station {
  const factory Station({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    String? brand,
    @Default([]) List<String> fuelTypes,
    @Default({}) Map<String, double> prices,
    @Default(false) bool hasCompressedAir,
    @Default({}) Map<String, String> address,
    String? openingHours,
    @Default(false) bool wheelchairAccessible,
    required String geometryType,
    List<LatLng>? polygonCoordinates,
    @Default(false) bool isOpen,
    // isFaborite
    @Default(false) bool isFavorite,
    //
  }) = _Station;

  factory Station.fromJson(Map<String, dynamic> json) => _$StationFromJson(json);

  factory Station.fromGeoJson(Map<String, dynamic> feature) {
    final properties = feature['properties'] as Map<String, dynamic>;
    final geometry = feature['geometry'] as Map<String, dynamic>;
    final geometryType = geometry['type'] as String;
    
    double latitude;
    double longitude;
    List<LatLng>? polygonCoordinates;
    
    if (geometryType == 'Point') {
      final coordinates = geometry['coordinates'] as List;
      longitude = coordinates[0];
      latitude = coordinates[1];
    } else if (geometryType == 'Polygon') {
      final rings = geometry['coordinates'] as List;
      final firstRing = rings[0] as List;
      
      polygonCoordinates = [];
      double sumLat = 0;
      double sumLng = 0;
      
      for (var point in firstRing) {
        final lng = point[0] as double;
        final lat = point[1] as double;
        polygonCoordinates.add(LatLng(lat, lng));
        
        sumLng += lng;
        sumLat += lat;
      }
      
      longitude = sumLng / firstRing.length;
      latitude = sumLat / firstRing.length;
    } else {
      longitude = 0.0;
      latitude = 0.0;
    }

    List<String> fuelTypes = [];
    if (properties.containsKey('fuel:diesel') && properties['fuel:diesel'] == 'yes') {
      fuelTypes.add('Diesel');
    }
    if (properties.containsKey('fuel:e10') && properties['fuel:e10'] == 'yes') {
      fuelTypes.add('E10');
    }
    if (properties.containsKey('fuel:e85') && properties['fuel:e85'] == 'yes') {
      fuelTypes.add('E85');
    }
    if (properties.containsKey('fuel:lpg') && properties['fuel:lpg'] == 'yes') {
      fuelTypes.add('GPLc');
    }
    if (properties.containsKey('fuel:octane_95') && properties['fuel:octane_95'] == 'yes') {
      fuelTypes.add('SP95');
    }
    if (properties.containsKey('fuel:octane_98') && properties['fuel:octane_98'] == 'yes') {
      fuelTypes.add('SP98');
    }
    if (properties.containsKey('fuel:petrol') && properties['fuel:petrol'] == 'yes') {
      fuelTypes.add('SP95');
    }
    
    if (fuelTypes.isEmpty) {
      fuelTypes = ['Diesel', 'SP95'];
    }

    Map<String, double> prices = {};
    if (fuelTypes.contains('Diesel')) {
      prices['Diesel'] = 1.65 + (DateTime.now().millisecondsSinceEpoch % 20) / 100;
    }
    if (fuelTypes.contains('SP95')) {
      prices['SP95'] = 1.85 + (DateTime.now().millisecondsSinceEpoch % 15) / 100;
    }
     if (fuelTypes.contains('GPLc')) {
      prices['GPLc'] = 0.85 + (DateTime.now().millisecondsSinceEpoch % 5) / 100;
    }
     if (fuelTypes.contains('E85')) {
      prices['E85'] = 0.95 + (DateTime.now().millisecondsSinceEpoch % 10) / 100;
    }
    if (fuelTypes.contains('SP98')) {
      prices['SP98'] = 1.95 + (DateTime.now().millisecondsSinceEpoch % 10) / 100;
    }
    if (fuelTypes.contains('E10')) {
      prices['E10'] = 1.75 + (DateTime.now().millisecondsSinceEpoch % 25) / 100;
    }
   
   

    Map<String, String> address = {};
    final addressPrefixes = ['addr:street', 'addr:city', 'addr:country', 'addr:district', 'addr:postcode'];
    
    for (var prefix in addressPrefixes) {
      if (properties.containsKey(prefix)) {
        final key = prefix.split(':')[1];
        address[key] = properties[prefix];
      }
    }

    final hasCompressedAir = properties['compressed_air'] == 'yes';
    final openingHours = properties['opening_hours'] as String?;
    final wheelchairAccessible = properties['wheelchair'] == 'yes';
    
    String name = properties['name'] ?? 'Unknown Station';
    if (name == 'Unknown Station' && properties.containsKey('brand')) {
      name = properties['brand'];
    }

    return Station(
      id: feature['id'] ?? '',
      name: name,
      latitude: latitude,
      longitude: longitude,
      brand: properties['brand'],
      fuelTypes: fuelTypes,
      prices: prices,
      hasCompressedAir: hasCompressedAir,
      address: address,
      openingHours: openingHours,
      wheelchairAccessible: wheelchairAccessible,
      geometryType: geometryType,
      polygonCoordinates: polygonCoordinates,
      isOpen: false,
    );
  }
}

extension StationX on Station {
  String get formattedAddress {
    if (address.isEmpty) return '';
    
    final parts = <String>[];
    if (address.containsKey('street')) parts.add(address['street']!);
    if (address.containsKey('district')) parts.add(address['district']!);
    if (address.containsKey('city')) parts.add(address['city']!);
    if (address.containsKey('postcode')) parts.add(address['postcode']!);
    if (address.containsKey('country')) parts.add(address['country']!);
    
    return parts.join(', ');
  }
  
  LatLng get location => LatLng(latitude, longitude);
  
  bool hasFuelType(String fuelType) => fuelTypes.contains(fuelType);
  
  double? getPriceForFuel(String fuelType) => prices[fuelType];
}