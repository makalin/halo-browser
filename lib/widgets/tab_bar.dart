import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/providers/browser_provider.dart';
import 'package:halo_browser/models/tab.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Consumer<BrowserProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.tabs.length + 1,
            itemBuilder: (context, index) {
              if (index == provider.tabs.length) {
                return _NewTabButton(provider: provider);
              }
              return _TabItem(
                tab: provider.tabs[index],
                isActive: provider.currentTab?.id == provider.tabs[index].id,
                onTap: () => provider.switchTab(provider.tabs[index].id),
                onClose: () => provider.closeTab(provider.tabs[index].id),
              );
            },
          );
        },
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final BrowserTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const _TabItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            if (tab.favicon != null)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.network(
                  tab.favicon!,
                  width: 16,
                  height: 16,
                ),
              ),
            Expanded(
              child: Text(
                tab.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isActive
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}

class _NewTabButton extends StatelessWidget {
  final BrowserProvider provider;

  const _NewTabButton({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          // TODO: Implement new tab
        },
      ),
    );
  }
} 