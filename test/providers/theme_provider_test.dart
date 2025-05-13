import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halo_browser/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ThemeProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    provider = ThemeProvider();
  });

  group('ThemeProvider', () {
    test('initial theme mode is dark', () {
      expect(provider.themeMode, ThemeMode.dark);
      expect(provider.isDarkMode, true);
    });

    test('setThemeMode updates theme mode', () async {
      await provider.setThemeMode(ThemeMode.light);
      expect(provider.themeMode, ThemeMode.light);
      expect(provider.isDarkMode, false);

      await provider.setThemeMode(ThemeMode.dark);
      expect(provider.themeMode, ThemeMode.dark);
      expect(provider.isDarkMode, true);
    });

    test('loads saved theme mode from preferences', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': ThemeMode.light.toString(),
      });
      provider = ThemeProvider();
      expect(provider.themeMode, ThemeMode.light);
      expect(provider.isDarkMode, false);
    });

    test('falls back to dark mode if saved theme is invalid', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': 'invalid_theme_mode',
      });
      provider = ThemeProvider();
      expect(provider.themeMode, ThemeMode.dark);
      expect(provider.isDarkMode, true);
    });
  });
} 