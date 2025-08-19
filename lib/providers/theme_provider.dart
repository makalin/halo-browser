import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  late SharedPreferences _prefs;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _isDarkMode = mode == ThemeMode.dark;
    await _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
} 