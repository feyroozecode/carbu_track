// Settings state
import 'package:riverpod/riverpod.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsState {
  final String language;
  final String theme;
  final bool notifications;
  final String preferredFuel;
  final String currency;
  final String version;

  SettingsState({
    this.language = 'fr',
    this.theme = 'dark',
    this.notifications = true,
    this.preferredFuel = 'Diesel',
    this.currency = 'F CFA (XOF)',
    this.version = '1.0.0',
  });

  SettingsState copyWith({
    String? language,
    String? theme,
    bool? notifications,
    String? preferredFuel,
    String? currency,
    String? version,
  }) {
    return SettingsState(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notifications: notifications ?? this.notifications,
      preferredFuel: preferredFuel ?? this.preferredFuel,
      currency: currency ?? this.currency,
      version: version ?? this.version,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState());

  void updateLanguage(String language) =>
      state = state.copyWith(language: language);
  void updateTheme(String theme) => state = state.copyWith(theme: theme);
  void toggleNotifications() =>
      state = state.copyWith(notifications: !state.notifications);
  void updatePreferredFuel(String fuel) =>
      state = state.copyWith(preferredFuel: fuel);
  void updateCurrency(String currency) =>
      state = state.copyWith(currency: currency);
}
