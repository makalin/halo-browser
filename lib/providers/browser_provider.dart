import 'package:flutter/foundation.dart';
import 'package:halo_browser/models/tab.dart';
import 'package:url_launcher/url_launcher.dart';

class BrowserProvider with ChangeNotifier {
  final List<BrowserTab> _tabs = [];
  BrowserTab? _currentTab;
  bool _isLoading = false;
  final List<String> _navigationHistory = [];
  int _currentHistoryIndex = -1;
  
  // Loading state tracking
  DateTime? _loadingStartTime;
  int _loadingDurationSeconds = 0;
  
  // Page cache for faster loading
  final Map<String, String> _pageCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(hours: 1);

  List<BrowserTab> get tabs => _tabs;
  BrowserTab? get currentTab => _currentTab;
  bool get isLoading => _isLoading;
  bool get canGoBack => _currentHistoryIndex > 0;
  bool get canGoForward => _currentHistoryIndex < _navigationHistory.length - 1;
  int get loadingDurationSeconds => _loadingDurationSeconds;

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
    final tab = _tabs.firstWhere((tab) => tab.id == tabId);
    if (_currentTab?.id != tab.id) {
      _currentTab = tab;
      notifyListeners();
    }
  }

  void closeTab(String tabId) {
    final wasCurrentTab = _currentTab?.id == tabId;
    _tabs.removeWhere((tab) => tab.id == tabId);
    
    if (wasCurrentTab) {
      _currentTab = _tabs.isNotEmpty ? _tabs.last : null;
    }
    
    if (_tabs.isEmpty) {
      _addNewTab();
    }
    notifyListeners();
  }

  void updateCurrentTabUrl(String url) {
    if (_currentTab != null && _currentTab!.url != url) {
      _currentTab!.url = url;
      _updateTabTitle();
      _addToHistory(url);
      notifyListeners();
    }
  }

  void updateCurrentTabTitle(String title) {
    if (_currentTab != null && _currentTab!.title != title) {
      _currentTab!.title = title;
      notifyListeners();
    }
  }

  void _updateTabTitle() {
    if (_currentTab != null) {
      final url = _currentTab!.url;
      if (url.startsWith('about:')) {
        _currentTab!.title = 'New Tab';
      } else {
        // Extract domain from URL for a cleaner title
        try {
          final uri = Uri.parse(url);
          final domain = uri.host.isNotEmpty ? uri.host : url;
          _currentTab!.title = domain;
        } catch (e) {
          _currentTab!.title = url;
        }
      }
    }
  }

  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      
      if (loading) {
        _loadingStartTime = DateTime.now();
        _loadingDurationSeconds = 0;
        // Start duration counter
        _startLoadingTimer();
      } else {
        _loadingStartTime = null;
        _loadingDurationSeconds = 0;
      }
      
      notifyListeners();
    }
  }

  void _startLoadingTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isLoading && _loadingStartTime != null) {
        _loadingDurationSeconds = DateTime.now().difference(_loadingStartTime!).inSeconds;
        notifyListeners();
        _startLoadingTimer(); // Continue counting
      }
    });
  }

  void _addToHistory(String url) {
    // Remove any forward history when navigating to a new URL
    if (_currentHistoryIndex < _navigationHistory.length - 1) {
      _navigationHistory.removeRange(_currentHistoryIndex + 1, _navigationHistory.length);
    }
    
    // Only add if it's different from the current URL
    if (_navigationHistory.isEmpty || _navigationHistory.last != url) {
      _navigationHistory.add(url);
      _currentHistoryIndex = _navigationHistory.length - 1;
    }
  }

  Future<void> navigateToUrl(String url) async {
    if (_currentTab != null) {
      _currentTab!.url = url;
      _updateTabTitle();
      _addToHistory(url);
      
      // Try to launch URL if it's not an internal page
      if (!url.startsWith('about:')) {
        await _launchUrl(url);
      }
      
      notifyListeners();
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Failed to launch URL: $e');
    }
  }

  void goBack() {
    if (canGoBack) {
      _currentHistoryIndex--;
      final url = _navigationHistory[_currentHistoryIndex];
      if (_currentTab != null && _currentTab!.url != url) {
        _currentTab!.url = url;
        _updateTabTitle();
        notifyListeners();
      }
    }
  }

  void goForward() {
    if (canGoForward) {
      _currentHistoryIndex++;
      final url = _navigationHistory[_currentHistoryIndex];
      if (_currentTab != null && _currentTab!.url != url) {
        _currentTab!.url = url;
        _updateTabTitle();
        notifyListeners();
      }
    }
  }

  void reload() {
    // This would trigger a reload in the WebView
    // For now, just notify listeners
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

  // Page caching methods
  void cachePage(String url, String content) {
    _pageCache[url] = content;
    _cacheTimestamps[url] = DateTime.now();
    _cleanupExpiredCache();
  }

  String? getCachedPage(String url) {
    final timestamp = _cacheTimestamps[url];
    if (timestamp != null && 
        DateTime.now().difference(timestamp) < _cacheExpiry) {
      return _pageCache[url];
    }
    return null;
  }

  void _cleanupExpiredCache() {
    final now = DateTime.now();
    final expiredUrls = _cacheTimestamps.entries
        .where((entry) => now.difference(entry.value) > _cacheExpiry)
        .map((entry) => entry.key)
        .toList();
    
    for (final url in expiredUrls) {
      _pageCache.remove(url);
      _cacheTimestamps.remove(url);
    }
  }

  void clearCache() {
    _pageCache.clear();
    _cacheTimestamps.clear();
    notifyListeners();
  }
} 