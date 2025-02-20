import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PreferenceService extends StateNotifier<String> {
  static const String _themeKey = 'theme';
  late Box _preferencesBox;

  PreferenceService() : super('light') {
    _init();
  }

  Future<void> _init() async {
    _preferencesBox = await Hive.openBox('preferences');
    String savedTheme = _preferencesBox.get(_themeKey, defaultValue: 'light');
    state = savedTheme;
  }

  void toggleTheme() {
    state = state == 'light' ? 'dark' : 'light';
    _preferencesBox.put(_themeKey, state);
  }
}
final preferenceServiceProvider =
    StateNotifierProvider<PreferenceService, String>((ref) {
  return PreferenceService();
});
