import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/providers/browser_provider.dart';
import 'package:halo_browser/models/tab.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BrowserProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // New tab button
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: provider.addNewTab,
                tooltip: 'New tab',
                padding: const EdgeInsets.all(8),
              ),
              
              // Tab list
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.tabs.length,
                  itemBuilder: (context, index) {
                    final tab = provider.tabs[index];
                    final isActive = provider.currentTab?.id == tab.id;
                    
                    return _TabItem(
                      tab: tab,
                      isActive: isActive,
                      onTap: () => provider.switchTab(tab.id),
                      onClose: () => provider.closeTab(tab.id),
                      onDuplicate: () => provider.duplicateTab(tab.id),
                      onCloseOthers: () => provider.closeAllTabsExcept(tab.id),
                    );
                  },
                ),
              ),
              
              // Tab actions
              if (provider.tabs.length > 1)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'Tab actions',
                  onSelected: (value) {
                    switch (value) {
                      case 'close_all':
                        _showCloseAllConfirmation(context, provider);
                        break;
                      case 'close_others':
                        if (provider.currentTab != null) {
                          provider.closeAllTabsExcept(provider.currentTab!.id);
                        }
                        break;
                      case 'duplicate':
                        if (provider.currentTab != null) {
                          provider.duplicateTab(provider.currentTab!.id);
                        }
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (provider.currentTab != null) ...[
                      const PopupMenuItem(
                        value: 'duplicate',
                        child: Row(
                          children: [
                            Icon(Icons.copy, size: 16),
                            SizedBox(width: 8),
                            Text('Duplicate tab'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'close_others',
                        child: Row(
                          children: [
                            Icon(Icons.close, size: 16),
                            SizedBox(width: 8),
                            Text('Close other tabs'),
                          ],
                        ),
                      ),
                    ],
                    const PopupMenuItem(
                      value: 'close_all',
                      child: Row(
                        children: [
                          Icon(Icons.close, size: 16),
                          SizedBox(width: 8),
                          Text('Close all tabs'),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  void _showCloseAllConfirmation(BuildContext context, BrowserProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close all tabs?'),
        content: const Text('This will close all open tabs. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.closeAllTabs();
              Navigator.of(context).pop();
            },
            child: const Text('Close all'),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final BrowserTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onClose;
  final VoidCallback onDuplicate;
  final VoidCallback onCloseOthers;

  const _TabItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
    required this.onClose,
    required this.onDuplicate,
    required this.onCloseOthers,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onSecondaryTap: () => _showContextMenu(context),
      child: Container(
        constraints: const BoxConstraints(minWidth: 120, maxWidth: 200),
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          color: isActive 
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: isActive 
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            // Tab icon
            Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(left: 8),
              child: _getTabIcon(tab.url),
            ),
            
            const SizedBox(width: 8),
            
            // Tab title
            Expanded(
              child: Text(
                tab.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive 
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            
            // Close button
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: onClose,
              tooltip: 'Close tab',
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
              color: isActive 
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTabIcon(String url) {
    if (url.startsWith('about:')) {
      return const Icon(Icons.home, size: 16);
    } else if (url.startsWith('https://')) {
      return const Icon(Icons.lock, size: 16);
    } else if (url.startsWith('http://')) {
      return const Icon(Icons.info, size: 16);
    } else {
      return const Icon(Icons.web, size: 16);
    }
  }

  void _showContextMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero);
    
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        offset.dx + button.size.width,
        offset.dy + button.size.height,
      ),
      items: [
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.copy, size: 16),
              SizedBox(width: 8),
              Text('Duplicate tab'),
            ],
          ),
          onTap: onDuplicate,
        ),
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.close, size: 16),
              SizedBox(width: 8),
              Text('Close other tabs'),
            ],
          ),
          onTap: onCloseOthers,
        ),
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.close, size: 16),
              SizedBox(width: 8),
              Text('Close tab'),
            ],
          ),
          onTap: onClose,
        ),
      ],
    );
  }
} 