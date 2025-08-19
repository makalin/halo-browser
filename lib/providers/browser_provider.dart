import 'package:flutter/foundation.dart';
import 'package:halo_browser/models/tab.dart';
import 'package:halo_browser/providers/history_provider.dart';

class BrowserProvider with ChangeNotifier {
  List<BrowserTab> _tabs = [];
  BrowserTab? _currentTab;
  bool _isLoading = false;
  final List<String> _navigationHistory = [];
  int _currentHistoryIndex = -1;

  List<BrowserTab> get tabs => _tabs;
  BrowserTab? get currentTab => _currentTab;
  bool get isLoading => _isLoading;
  bool get canGoBack => _currentHistoryIndex > 0;
  bool get canGoForward => _currentHistoryIndex < _navigationHistory.length - 1;

  BrowserProvider() {
    _addNewTab();
  }

  void _addNewTab() {
    final newTab = BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Tab',
      url: 'about:blank',
    );
    _tabs.add(newTab);
    _currentTab = newTab;
    _addToHistory('about:blank');
    notifyListeners();
  }

  void switchTab(String tabId) {
    _currentTab = _tabs.firstWhere((tab) => tab.id == tabId);
    notifyListeners();
  }

  void closeTab(String tabId) {
    _tabs.removeWhere((tab) => tab.id == tabId);
    if (_currentTab?.id == tabId) {
      _currentTab = _tabs.isNotEmpty ? _tabs.last : null;
    }
    if (_tabs.isEmpty) {
      _addNewTab();
    }
    notifyListeners();
  }

  void updateCurrentTabUrl(String url) {
    if (_currentTab != null) {
      _currentTab!.url = url;
      _addToHistory(url);
      notifyListeners();
    }
  }

  void updateCurrentTabTitle(String title) {
    if (_currentTab != null) {
      _currentTab!.title = title;
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _addToHistory(String url) {
    // Remove any forward history when navigating to a new URL
    if (_currentHistoryIndex < _navigationHistory.length - 1) {
      _navigationHistory.removeRange(_currentHistoryIndex + 1, _navigationHistory.length);
    }
    
    _navigationHistory.add(url);
    _currentHistoryIndex = _navigationHistory.length - 1;
  }

  void navigateToUrl(String url) {
    if (_currentTab != null) {
      _currentTab!.url = url;
      _addToHistory(url);
      notifyListeners();
    }
  }

  void goBack() {
    if (canGoBack) {
      _currentHistoryIndex--;
      final url = _navigationHistory[_currentHistoryIndex];
      if (_currentTab != null) {
        _currentTab!.url = url;
      }
      notifyListeners();
    }
  }

  void goForward() {
    if (canGoForward) {
      _currentHistoryIndex++;
      final url = _navigationHistory[_currentHistoryIndex];
      if (_currentTab != null) {
        _currentTab!.url = url;
      }
      notifyListeners();
    }
  }

  void reload() {
    // This would trigger a reload in the WebView
    notifyListeners();
  }

  void addNewTab() {
    _addNewTab();
  }

  void duplicateTab(String tabId) {
    final originalTab = _tabs.firstWhere((tab) => tab.id == tabId);
    final newTab = BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${originalTab.title} (Copy)',
      url: originalTab.url,
    );
    _tabs.add(newTab);
    _currentTab = newTab;
    notifyListeners();
  }

  void moveTab(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _tabs.removeAt(oldIndex);
    _tabs.insert(newIndex, item);
    notifyListeners();
  }

  void closeAllTabsExcept(String tabId) {
    _tabs.removeWhere((tab) => tab.id != tabId);
    _currentTab = _tabs.first;
    notifyListeners();
  }

  void closeAllTabs() {
    _tabs.clear();
    _addNewTab();
  }
} 