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
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          _buildSectionHeader(context, 'Appearance'),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Card(
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Light Theme'),
                      subtitle: const Text('Use light colors'),
                      value: ThemeMode.light,
                      groupValue: themeProvider.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Dark Theme'),
                      subtitle: const Text('Use dark colors'),
                      value: ThemeMode.dark,
                      groupValue: themeProvider.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('System Theme'),
                      subtitle: const Text('Follow system preference'),
                      value: ThemeMode.system,
                      groupValue: themeProvider.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Browser Settings Section
          _buildSectionHeader(context, 'Browser Settings'),
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Card(
                child: Column(
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
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showSearchEngineDialog(context, settings),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Privacy & Data Section
          _buildSectionHeader(context, 'Privacy & Data'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Clear Browsing Data'),
                  subtitle: const Text('Remove browsing history, cookies, and cache'),
                  leading: const Icon(Icons.delete_sweep),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showClearDataDialog(context),
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  subtitle: const Text('View our privacy policy'),
                  leading: const Icon(Icons.privacy_tip),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Navigate to privacy policy
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // About Section
          _buildSectionHeader(context, 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Version'),
                  subtitle: const Text('1.0.0'),
                  leading: const Icon(Icons.info),
                ),
                ListTile(
                  title: const Text('Open Source'),
                  subtitle: const Text('View source code on GitHub'),
                  leading: const Icon(Icons.code),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Open GitHub repository
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
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
              leading: const Icon(Icons.search),
              onTap: () {
                settings.setDefaultSearchEngine('Google');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('DuckDuckGo'),
              leading: const Icon(Icons.search),
              onTap: () {
                settings.setDefaultSearchEngine('DuckDuckGo');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Bing'),
              leading: const Icon(Icons.search),
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

  void _showClearDataDialog(BuildContext context) {
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
              // TODO: Implement clear browsing data
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Browsing data cleared')),
              );
            },
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }
} 