import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/screens/browser_screen.dart';
import 'package:halo_browser/providers/theme_provider.dart';
import 'package:halo_browser/providers/browser_provider.dart';
import 'package:halo_browser/providers/settings_provider.dart';
import 'package:halo_browser/providers/bookmarks_provider.dart';
import 'package:halo_browser/providers/downloads_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HaloBrowser());
}

class HaloBrowser extends StatelessWidget {
  const HaloBrowser({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BrowserProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => BookmarksProvider()),
        ChangeNotifierProvider(create: (_) => DownloadsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Halo Browser',
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: themeProvider.themeMode,
            home: const BrowserScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
} 