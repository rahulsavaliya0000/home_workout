import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Define a key for storing the theme preference
  static const String themePreferenceKey = 'theme_preference';

  ThemeProvider() {
    // Load the theme preference when the provider is initialized
    _loadThemePreference();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemePreference(); // Save the updated theme preference
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(themePreferenceKey) ?? false;
  }

  Future<void> _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themePreferenceKey, _isDarkMode);
  }
}
