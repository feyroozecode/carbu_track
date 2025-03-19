import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFavoriteRemoteService {
  SupabaseFavoriteRemoteService({required this.supabase});

  final SupabaseClient supabase;

  Future<void> addToFavorites({
    required double latitude,
    required double longitude,
    required String userId,
  }) async {
    try {
      await supabase.from('favorites').insert({
        'user_id': userId,
        'lat': latitude,
        'lng': longitude,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add location to favorites: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    try {
      final response = await supabase
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch favorites: $e');
    }
  }

  Future<void> removeFavorite(int favoriteId) async {
    try {
      await supabase.from('favorites').delete().eq('id', favoriteId);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }
}
