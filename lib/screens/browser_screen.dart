import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:halo_browser/widgets/address_bar.dart';
import 'package:halo_browser/widgets/tab_bar.dart';
import 'package:halo_browser/providers/browser_provider.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/screens/bookmarks_screen.dart';
import 'package:halo_browser/screens/downloads_screen.dart';
import 'package:halo_browser/screens/settings_screen.dart';
import 'package:halo_browser/screens/history_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomTabBar(),
        const AddressBar(),
        Expanded(
          child: Consumer<BrowserProvider>(
            builder: (context, provider, child) {
              final currentTab = provider.currentTab;
              if (currentTab == null) {
                return const Center(
                  child: Text('No tabs open'),
                );
              }

              return Stack(
                children: [
                  // InAppWebView is not supported on web, so we use a placeholder
                  Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Text('WebView not supported on web platform'),
                    ),
                  ),
                  if (provider.isLoading)
                    const LinearProgressIndicator(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
} 