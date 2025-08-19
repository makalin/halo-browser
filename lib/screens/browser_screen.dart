import 'package:flutter/material.dart';
import 'package:halo_browser/widgets/address_bar.dart';
import 'package:halo_browser/widgets/tab_bar.dart';
import 'package:halo_browser/providers/browser_provider.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/screens/bookmarks_screen.dart';
import 'package:halo_browser/screens/downloads_screen.dart';
import 'package:halo_browser/screens/settings_screen.dart';
import 'package:halo_browser/screens/history_screen.dart';
import 'package:halo_browser/providers/theme_provider.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _BrowserContent(),
    const BookmarksScreen(),
    const HistoryScreen(),
    const DownloadsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.web),
            label: 'Browser',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.download),
            label: 'Downloads',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _BrowserContent extends StatelessWidget {
  const _BrowserContent();

  IconData _getUrlIcon(String url) {
    if (url.startsWith('about:')) {
      return Icons.home;
    } else if (url.startsWith('https://')) {
      return Icons.lock;
    } else if (url.startsWith('http://')) {
      return Icons.info;
    } else {
      return Icons.web;
    }
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomTabBar(),
        Row(
          children: [
            Expanded(child: const AddressBar()),
            // Theme toggle button
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode 
                      ? Icons.light_mode 
                      : Icons.dark_mode,
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                  tooltip: themeProvider.isDarkMode 
                    ? 'Switch to light mode' 
                    : 'Switch to dark mode',
                );
              },
            ),
          ],
        ),
        Expanded(
          child: Consumer<BrowserProvider>(
            builder: (context, provider, child) {
              final currentTab = provider.currentTab;
              if (currentTab == null) {
                return const Center(
                  child: Text('No tabs open'),
                );
              }

              return Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    // URL display bar
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getUrlIcon(currentTab.url),
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              currentTab.url,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (provider.isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                    ),
                    
                    // Browser content area
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.web,
                                size: 80,
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Halo Browser',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Fast, Privacy-Focused Browsing',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Web version - Use desktop app for full functionality',
                                ),
                              ),
                              const SizedBox(height: 32),
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  _buildFeatureCard(
                                    context,
                                    Icons.security,
                                    'Privacy First',
                                    'No tracking, no telemetry',
                                  ),
                                  _buildFeatureCard(
                                    context,
                                    Icons.speed,
                                    'Lightning Fast',
                                    'Optimized for performance',
                                  ),
                                  _buildFeatureCard(
                                    context,
                                    Icons.devices,
                                    'Cross Platform',
                                    'Works everywhere',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 