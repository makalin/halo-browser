import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/providers/theme_provider.dart';
import 'package:halo_browser/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Enable dark theme'),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              );
            },
          ),
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable JavaScript'),
                    subtitle: const Text('Allow JavaScript execution'),
                    value: settings.isJavaScriptEnabled,
                    onChanged: settings.setJavaScriptEnabled,
                  ),
                  SwitchListTile(
                    title: const Text('Block Ads'),
                    subtitle: const Text('Enable ad blocking'),
                    value: settings.isAdBlockingEnabled,
                    onChanged: settings.setAdBlockingEnabled,
                  ),
                  SwitchListTile(
                    title: const Text('Do Not Track'),
                    subtitle: const Text('Send Do Not Track requests'),
                    value: settings.isDoNotTrackEnabled,
                    onChanged: settings.setDoNotTrackEnabled,
                  ),
                  ListTile(
                    title: const Text('Default Search Engine'),
                    subtitle: Text(settings.defaultSearchEngine),
                    onTap: () => _showSearchEngineDialog(context, settings),
                  ),
                  ListTile(
                    title: const Text('Clear Browsing Data'),
                    onTap: () => _showClearDataDialog(context, settings),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSearchEngineDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Search Engine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Google'),
              onTap: () {
                settings.setDefaultSearchEngine('Google');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('DuckDuckGo'),
              onTap: () {
                settings.setDefaultSearchEngine('DuckDuckGo');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Bing'),
              onTap: () {
                settings.setDefaultSearchEngine('Bing');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Browsing Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Browsing History'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Cookies and Site Data'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Cached Images and Files'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              settings.clearBrowsingData();
              Navigator.pop(context);
            },
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }
} 