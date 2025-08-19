import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isJavaScriptEnabled = true;
  bool _isAdBlockingEnabled = false;
  bool _isDoNotTrackEnabled = false;
  String _defaultSearchEngine = 'Google';

  bool get isJavaScriptEnabled => _isJavaScriptEnabled;
  bool get isAdBlockingEnabled => _isAdBlockingEnabled;
  bool get isDoNotTrackEnabled => _isDoNotTrackEnabled;
  String get defaultSearchEngine => _defaultSearchEngine;

  void setJavaScriptEnabled(bool value) {
    _isJavaScriptEnabled = value;
    notifyListeners();
  }

  void setAdBlockingEnabled(bool value) {
    _isAdBlockingEnabled = value;
    notifyListeners();
  }

  void setDoNotTrackEnabled(bool value) {
    _isDoNotTrackEnabled = value;
    notifyListeners();
  }

  void setDefaultSearchEngine(String value) {
    _defaultSearchEngine = value;
    notifyListeners();
  }

  void clearBrowsingData() {
    // TODO: Implement clearing browsing data
    notifyListeners();
  }
} 