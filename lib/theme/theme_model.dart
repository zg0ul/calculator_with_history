import 'package:calculator_with_history/theme/theme_preferences.dart';
import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDarkTheme = true;
  ThemePreferences _preferences = ThemePreferences();
  bool get isDarkTheme => _isDarkTheme;
  
  ThemeModel() {
    _isDarkTheme = true;
    _preferences = ThemePreferences();
    getPreferences();
  }

  getPreferences() async {
    _isDarkTheme = await _preferences.getTheme();
    notifyListeners();
  }

  set isDarkTheme(bool value) {
    _isDarkTheme = value;
    _preferences.setTheme(value);
    notifyListeners();
  }
}