import 'package:hive_ce/hive.dart';

class FavoriteLocalService {
  static const String _boxName = 'favorites';
  late Box<dynamic> _box;

  // Initialize Hive and open box
  Future<void> init() async {
    //_box = await Hive.openBox(_boxName);
    if (_box.isOpen) {
      _box = Hive.box(_boxName);
    } else {
      _box = await Hive.openBox(_boxName);
    }
  }

  // Save favorite item
  Future<void> saveFavorite(String key, dynamic value) async {
    await _box.put(key, value);
  }

  // Get favorite item by key
  dynamic getFavorite(String key) {
    return _box.get(key);
  }

  // Get all favorites
  Map<dynamic, dynamic> getAllFavorites() {
    return _box.toMap();
  }

  // Delete favorite item
  Future<void> deleteFavorite(String key) async {
    await _box.delete(key);
  }

  // Check if favorite exists
  bool hasFavorite(String key) {
    return _box.containsKey(key);
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    await _box.clear();
  }
}
