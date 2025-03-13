import 'package:riverpod/riverpod.dart';

final moodlevelProvider =
    StateNotifierProvider<MoodNotifier, int>((ref) => MoodNotifier());

class MoodNotifier extends StateNotifier<int> {
  MoodNotifier() : super(0);

  void updateMood(int newMood) {
    state = newMood;
    print("new state $state");
    // Sauvegarder dans Hive/SQLite
  }

  int get mood => state;
}
