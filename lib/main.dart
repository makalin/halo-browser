import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/providers/theme_provider.dart';
import 'package:halo_browser/providers/browser_provider.dart';
import 'package:halo_browser/providers/settings_provider.dart';
import 'package:halo_browser/providers/bookmarks_provider.dart';
import 'package:halo_browser/providers/downloads_provider.dart';
import 'package:halo_browser/providers/history_provider.dart';
import 'package:halo_browser/providers/window_settings_provider.dart';
import 'package:halo_browser/providers/ai_provider.dart';
import 'package:halo_browser/providers/logging_provider.dart';
import 'package:halo_browser/providers/script_engine_provider.dart';
import 'package:halo_browser/screens/browser_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BrowserProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => BookmarksProvider()),
        ChangeNotifierProvider(create: (_) => DownloadsProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => WindowSettingsProvider()),
        ChangeNotifierProvider(create: (_) => AIProvider()),
        ChangeNotifierProvider(create: (_) => LoggingProvider()),
        ChangeNotifierProvider(create: (_) => ScriptEngineProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Halo Browser',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const BrowserScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
} 