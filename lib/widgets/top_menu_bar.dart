import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/providers/browser_provider.dart';
import 'package:halo_browser/providers/theme_provider.dart';
import 'package:halo_browser/providers/window_settings_provider.dart';

class TopMenuBar extends StatelessWidget {
  const TopMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WindowSettingsProvider>(
      builder: (context, windowSettings, child) {
        return Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // App menu button
              PopupMenuButton<String>(
                icon: const Icon(Icons.menu, size: 20),
                tooltip: 'App menu',
                onSelected: (value) => _handleMenuAction(context, value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'new_tab',
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 16),
                        SizedBox(width: 8),
                        Text('New Tab'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'new_window',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_new, size: 16),
                        SizedBox(width: 8),
                        Text('New Window'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'bookmarks',
                    child: Row(
                      children: [
                        Icon(Icons.bookmark, size: 16),
                        SizedBox(width: 8),
                        Text('Bookmarks'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'history',
                    child: Row(
                      children: [
                        Icon(Icons.history, size: 16),
                        SizedBox(width: 8),
                        Text('History'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'downloads',
                    child: Row(
                      children: [
                        Icon(Icons.download, size: 16),
                        SizedBox(width: 8),
                        Text('Downloads'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings, size: 16),
                        SizedBox(width: 8),
                        Text('Settings'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'about',
                    child: Row(
                      children: [
                        Icon(Icons.info, size: 16),
                        SizedBox(width: 8),
                        Text('About Halo Browser'),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 8),
              
              // Window controls
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: () => windowSettings.setMinimized(true),
                    tooltip: 'Minimize',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      windowSettings.isMaximized ? Icons.crop_square : Icons.crop_square_outlined,
                      size: 18,
                    ),
                    onPressed: () => windowSettings.setMaximized(!windowSettings.isMaximized),
                    tooltip: windowSettings.isMaximized ? 'Restore' : 'Maximize',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      // TODO: Implement app close
                    },
                    tooltip: 'Close',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Theme toggle
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode 
                        ? Icons.light_mode 
                        : Icons.dark_mode,
                      size: 20,
                    ),
                    onPressed: () => themeProvider.toggleTheme(),
                    tooltip: themeProvider.isDarkMode 
                      ? 'Switch to light mode' 
                      : 'Switch to dark mode',
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleMenuAction(BuildContext context, String value) {
    switch (value) {
      case 'new_tab':
        context.read<BrowserProvider>().addNewTab();
        break;
      case 'new_window':
        // TODO: Implement new window
        break;
      case 'bookmarks':
        // TODO: Navigate to bookmarks
        break;
      case 'history':
        // TODO: Navigate to history
        break;
      case 'downloads':
        // TODO: Navigate to downloads
        break;
      case 'settings':
        // TODO: Navigate to settings
        break;
      case 'about':
        _showAboutDialog(context);
        break;
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Halo Browser',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.web,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        Text(
          'A lightning-fast, privacy-focused, and cross-platform web browser designed for modern devices.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Text(
          'Built with Flutter and Rust for maximum performance and security.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
