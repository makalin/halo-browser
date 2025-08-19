import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  late SharedPreferences _prefs;
  static const String _themeKey = 'isDarkMode';
  
  // Cache theme data to avoid rebuilding
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _initializeThemes();
    _loadTheme();
  }

  void _initializeThemes() {
    _lightTheme = _createLightTheme();
    _darkTheme = _createDarkTheme();
  }

  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool(_themeKey) ?? _getSystemThemePreference();
    notifyListeners();
  }

  bool _getSystemThemePreference() {
    try {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    } catch (e) {
      // Fallback to light theme if system preference can't be determined
      return false;
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveTheme();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    bool newDarkMode;
    switch (mode) {
      case ThemeMode.light:
        newDarkMode = false;
        break;
      case ThemeMode.dark:
        newDarkMode = true;
        break;
      case ThemeMode.system:
        newDarkMode = _getSystemThemePreference();
        break;
    }
    
    if (_isDarkMode != newDarkMode) {
      _isDarkMode = newDarkMode;
      await _saveTheme();
      notifyListeners();
    }
  }

  Future<void> _saveTheme() async {
    try {
      await _prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      // Handle storage errors gracefully
      debugPrint('Failed to save theme preference: $e');
    }
  }

  // Get cached theme data
  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;
  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;
  ColorScheme get currentColorScheme => _isDarkMode 
    ? _darkTheme.colorScheme 
    : _lightTheme.colorScheme;

  // Create light theme once and cache it
  ThemeData _createLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2196F3),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 8,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF2196F3).withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      tabBarTheme: const TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.black54,
      ),
    );
  }

  // Create dark theme once and cache it
  ThemeData _createDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF64B5F6),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 8,
        backgroundColor: const Color(0xFF1E1E1E),
        indicatorColor: const Color(0xFF64B5F6).withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      tabBarTheme: const TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF2C2C2C),
        modalBackgroundColor: Color(0xFF2C2C2C),
      ),
    );
  }
} 