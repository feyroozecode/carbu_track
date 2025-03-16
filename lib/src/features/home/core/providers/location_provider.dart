import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

// Provider for user's current location
final userLocationProvider = StateNotifierProvider<LocationNotifier, LatLng>((ref) {
  return LocationNotifier();
});

class LocationNotifier extends StateNotifier<LatLng> {
  // Default to Paris
  LocationNotifier() : super(const LatLng(13.5009779,7.1036396));

  void updateLocation(LatLng newLocation) {
    state = newLocation;
  }
  
}