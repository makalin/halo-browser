import 'package:flutter/foundation.dart';
import 'package:halo_browser/models/tab.dart';

class BrowserProvider with ChangeNotifier {
  List<BrowserTab> _tabs = [];
  BrowserTab? _currentTab;
  bool _isLoading = false;

  List<BrowserTab> get tabs => _tabs;
  BrowserTab? get currentTab => _currentTab;
  bool get isLoading => _isLoading;

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
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
} 