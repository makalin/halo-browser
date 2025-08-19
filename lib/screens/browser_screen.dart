import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/providers/browser_provider.dart';

import 'package:halo_browser/providers/window_settings_provider.dart';
import 'package:halo_browser/widgets/address_bar.dart';
import 'package:halo_browser/widgets/tab_bar.dart';
import 'package:halo_browser/widgets/top_menu_bar.dart';
import 'package:halo_browser/screens/bookmarks_screen.dart';
import 'package:halo_browser/screens/downloads_screen.dart';
import 'package:halo_browser/screens/settings_screen.dart';
import 'package:halo_browser/screens/history_screen.dart';
import 'package:halo_browser/screens/developer_tools_screen.dart';
import 'package:halo_browser/models/tab.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _BrowserContent(),
    const BookmarksScreen(),
    const DownloadsScreen(),
    const HistoryScreen(),
    const DeveloperToolsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<WindowSettingsProvider>(
      builder: (context, windowSettings, child) {
        return Scaffold(
          body: Column(
            children: [
              // Top menu bar
              const TopMenuBar(),
              
              // Address bar
              Container(
                padding: const EdgeInsets.all(16),
                child: const AddressBar(),
              ),
              
              // Tab bar
              const CustomTabBar(),
              
              // Main content area
              Expanded(
                child: _screens[_selectedIndex],
              ),
              
              // Bottom navigation (minimizable)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: windowSettings.isBottomNavVisible ? 80 : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: windowSettings.isBottomNavVisible ? 1.0 : 0.0,
                  child: NavigationBar(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
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
                        icon: Icon(Icons.download),
                        label: 'Downloads',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.history),
                        label: 'History',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.code),
                        label: 'Dev Tools',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => windowSettings.toggleBottomNav(),
            child: Icon(
              windowSettings.isBottomNavVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
            ),
          ),
        );
      },
    );
  }
}

class _BrowserContent extends StatelessWidget {
  const _BrowserContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<BrowserProvider>(
      builder: (context, browserProvider, child) {
        final currentTab = browserProvider.currentTab;
        final isLoading = browserProvider.isLoading;
        final loadingDuration = browserProvider.loadingDurationSeconds;
        
        // Update app title with URL and loading info
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (currentTab != null) {
            String title = 'Halo Browser';
            if (currentTab.url != 'about:blank') {
              title = '${currentTab.title} - Halo Browser';
              if (isLoading && loadingDuration > 0) {
                title = 'Loading... (${loadingDuration}s) - $title';
              }
            }
            // This would update the window title in a real desktop app
          }
        });

        return Column(
          children: [
            // Loading progress bar
            if (isLoading)
              LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            
            // Main content area
            Expanded(
              child: _buildContent(currentTab, isLoading),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BrowserTab? currentTab, bool isLoading) {
    if (currentTab == null || currentTab.url == 'about:blank') {
      return _buildWelcomeScreen();
    }

    if (isLoading) {
      return _buildLoadingScreen(currentTab.url);
    }

    return _buildUrlDisplay(currentTab.url);
  }

  Widget _buildWelcomeScreen() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.web,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          const Text(
            'Welcome to Halo Browser',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Enter a URL in the address bar above to start browsing.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildFeatureCard(
                Icons.psychology,
                'AI-Powered',
                'Get intelligent assistance and page analysis',
              ),
              _buildFeatureCard(
                Icons.code,
                'Developer Tools',
                'Advanced scripting and content extraction',
              ),
              _buildFeatureCard(
                Icons.security,
                'Privacy Focused',
                'Browse with enhanced privacy and security',
              ),
              _buildFeatureCard(
                Icons.speed,
                'Lightning Fast',
                'Optimized for speed and performance',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen(String url) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Loading...',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            url,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUrlDisplay(String url) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getUrlIcon(url),
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'Page Loaded',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'URL: $url',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'This is a web-compatible interface. In a desktop app, this would display the actual web page content.',
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.blue[600],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getUrlIcon(String url) {
    if (url.contains('github.com')) return Icons.code;
    if (url.contains('stackoverflow.com')) return Icons.question_answer;
    if (url.contains('youtube.com')) return Icons.play_circle;
    if (url.contains('google.com')) return Icons.search;
    if (url.contains('news') || url.contains('blog')) return Icons.article;
    if (url.contains('shop') || url.contains('store')) return Icons.shopping_cart;
    return Icons.web;
  }
} 