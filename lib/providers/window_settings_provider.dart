import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WindowSettingsProvider extends ChangeNotifier {
  static const String _windowSettingsKey = 'window_settings';
  
  double _windowWidth = 1200;
  double _windowHeight = 800;
  double _windowX = 100;
  double _windowY = 100;
  bool _isMaximized = false;
  bool _isMinimized = false;
  bool _bottomNavVisible = true;
  
  double get windowWidth => _windowWidth;
  double get windowHeight => _windowHeight;
  double get windowX => _windowX;
  double get windowY => _windowY;
  bool get isMaximized => _isMaximized;
  bool get isMinimized => _isMinimized;
  bool get bottomNavVisible => _bottomNavVisible;
  bool get isBottomNavVisible => _bottomNavVisible;

  WindowSettingsProvider() {
    _loadWindowSettings();
  }

  Future<void> _loadWindowSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_windowSettingsKey);
      
      if (settingsJson != null) {
        final settings = jsonDecode(settingsJson) as Map<String, dynamic>;
        _windowWidth = (settings['width'] as num?)?.toDouble() ?? 1200;
        _windowHeight = (settings['height'] as num?)?.toDouble() ?? 800;
        _windowX = (settings['x'] as num?)?.toDouble() ?? 100;
        _windowY = (settings['y'] as num?)?.toDouble() ?? 100;
        _isMaximized = settings['maximized'] as bool? ?? false;
        _isMinimized = settings['minimized'] as bool? ?? false;
        _bottomNavVisible = settings['bottomNavVisible'] as bool? ?? true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load window settings: $e');
    }
  }

  Future<void> _saveWindowSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settings = {
        'width': _windowWidth,
        'height': _windowHeight,
        'x': _windowX,
        'y': _windowY,
        'maximized': _isMaximized,
        'minimized': _isMinimized,
        'bottomNavVisible': _bottomNavVisible,
      };
      
      await prefs.setString(_windowSettingsKey, jsonEncode(settings));
    } catch (e) {
      debugPrint('Failed to save window settings: $e');
    }
  }

  void updateWindowSize(double width, double height) {
    if (_windowWidth != width || _windowHeight != height) {
      _windowWidth = width;
      _windowHeight = height;
      _saveWindowSettings();
      notifyListeners();
    }
  }

  void updateWindowPosition(double x, double y) {
    if (_windowX != x || _windowY != y) {
      _windowX = x;
      _windowY = y;
      _saveWindowSettings();
      notifyListeners();
    }
  }

  void setMaximized(bool maximized) {
    if (_isMaximized != maximized) {
      _isMaximized = maximized;
      _saveWindowSettings();
      notifyListeners();
    }
  }

  void setMinimized(bool minimized) {
    if (_isMinimized != minimized) {
      _isMinimized = minimized;
      _saveWindowSettings();
      notifyListeners();
    }
  }

  void toggleBottomNav() {
    _bottomNavVisible = !_bottomNavVisible;
    _saveWindowSettings();
    notifyListeners();
  }

  void setBottomNavVisible(bool visible) {
    if (_bottomNavVisible != visible) {
      _bottomNavVisible = visible;
      _saveWindowSettings();
      notifyListeners();
    }
  }

  void resetToDefaults() {
    _windowWidth = 1200;
    _windowHeight = 800;
    _windowX = 100;
    _windowY = 100;
    _isMaximized = false;
    _isMinimized = false;
    _bottomNavVisible = true;
    _saveWindowSettings();
    notifyListeners();
  }
}
