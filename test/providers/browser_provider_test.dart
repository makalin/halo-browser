import 'package:flutter_test/flutter_test.dart';
import 'package:halo_browser/providers/browser_provider.dart';
import 'package:halo_browser/models/tab.dart';

void main() {
  late BrowserProvider provider;

  setUp(() {
    provider = BrowserProvider();
  });

  group('BrowserProvider', () {
    test('initializes with one tab', () {
      expect(provider.tabs.length, 1);
      expect(provider.currentTab, isNotNull);
    });

    test('switchTab changes current tab', () {
      final firstTab = provider.tabs[0];
      provider._addNewTab();
      final secondTab = provider.tabs[1];

      provider.switchTab(firstTab.id);
      expect(provider.currentTab?.id, firstTab.id);

      provider.switchTab(secondTab.id);
      expect(provider.currentTab?.id, secondTab.id);
    });

    test('closeTab removes tab and updates current tab', () {
      final firstTab = provider.tabs[0];
      provider._addNewTab();
      final secondTab = provider.tabs[1];

      provider.closeTab(firstTab.id);
      expect(provider.tabs.length, 1);
      expect(provider.currentTab?.id, secondTab.id);
    });

    test('closeTab creates new tab when all tabs are closed', () {
      final firstTab = provider.tabs[0];
      provider.closeTab(firstTab.id);
      expect(provider.tabs.length, 1);
      expect(provider.currentTab, isNotNull);
    });

    test('updateCurrentTabUrl updates current tab URL', () {
      const newUrl = 'https://example.com';
      provider.updateCurrentTabUrl(newUrl);
      expect(provider.currentTab?.url, newUrl);
    });

    test('setLoading updates loading state', () {
      provider.setLoading(true);
      expect(provider.isLoading, true);

      provider.setLoading(false);
      expect(provider.isLoading, false);
    });
  });
} 