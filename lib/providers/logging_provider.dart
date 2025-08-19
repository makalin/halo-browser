import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

class LogEntry {
  final String id;
  final LogLevel level;
  final String message;
  final String? url;
  final String? stackTrace;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  LogEntry({
    required this.id,
    required this.level,
    required this.message,
    this.url,
    this.stackTrace,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level.name,
      'message': message,
      'url': url,
      'stackTrace': stackTrace,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      id: json['id'] ?? '',
      level: LogLevel.values.firstWhere(
        (level) => level.name == json['level'],
        orElse: () => LogLevel.info,
      ),
      message: json['message'] ?? '',
      url: json['url'],
      stackTrace: json['stackTrace'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
    );
  }
}

class PageIssue {
  final String id;
  final String type;
  final String description;
  final String url;
  final DateTime timestamp;
  final LogLevel severity;
  final Map<String, dynamic>? details;

  PageIssue({
    required this.id,
    required this.type,
    required this.description,
    required this.url,
    required this.timestamp,
    required this.severity,
    this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'url': url,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity.name,
      'details': details,
    };
  }

  factory PageIssue.fromJson(Map<String, dynamic> json) {
    return PageIssue(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      severity: LogLevel.values.firstWhere(
        (level) => level.name == json['severity'],
        orElse: () => LogLevel.warning,
      ),
      details: json['details'],
    );
  }
}

class LoggingProvider with ChangeNotifier {
  final List<LogEntry> _logs = [];
  final List<PageIssue> _pageIssues = [];
  final int _maxLogs = 1000;
  final int _maxIssues = 500;
  
  bool _isEnabled = true;
  LogLevel _minLogLevel = LogLevel.info;
  bool _autoCleanup = true;
  bool _notifyOnErrors = true;

  List<LogEntry> get logs => _logs;
  List<PageIssue> get pageIssues => _pageIssues;
  bool get isEnabled => _isEnabled;
  LogLevel get minLogLevel => _minLogLevel;
  bool get autoCleanup => _autoCleanup;
  bool get notifyOnErrors => _notifyOnErrors;

  LoggingProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isEnabled = prefs.getBool('logging_enabled') ?? true;
      _minLogLevel = LogLevel.values.firstWhere(
        (level) => level.name == (prefs.getString('logging_min_level') ?? 'info'),
        orElse: () => LogLevel.info,
      );
      _autoCleanup = prefs.getBool('logging_auto_cleanup') ?? true;
      _notifyOnErrors = prefs.getBool('logging_notify_errors') ?? true;
    } catch (e) {
      debugPrint('Failed to load logging settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logging_enabled', _isEnabled);
      await prefs.setString('logging_min_level', _minLogLevel.name);
      await prefs.setBool('logging_auto_cleanup', _autoCleanup);
      await prefs.setBool('logging_notify_errors', _notifyOnErrors);
    } catch (e) {
      debugPrint('Failed to save logging settings: $e');
    }
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    _saveSettings();
    notifyListeners();
  }

  void setMinLogLevel(LogLevel level) {
    _minLogLevel = level;
    _saveSettings();
    notifyListeners();
  }

  void setAutoCleanup(bool enabled) {
    _autoCleanup = enabled;
    _saveSettings();
    notifyListeners();
  }

  void setNotifyOnErrors(bool enabled) {
    _notifyOnErrors = enabled;
    _saveSettings();
    notifyListeners();
  }

  void log(LogLevel level, String message, {String? url, String? stackTrace, Map<String, dynamic>? metadata}) {
    if (!_isEnabled || level.index < _minLogLevel.index) return;

    final entry = LogEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      level: level,
      message: message,
      url: url,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    _logs.add(entry);
    
    if (_autoCleanup && _logs.length > _maxLogs) {
      _logs.removeRange(0, _logs.length - _maxLogs);
    }

    if (level.index >= LogLevel.error.index && _notifyOnErrors) {
      notifyListeners();
    }
  }

  void debug(String message, {String? url, Map<String, dynamic>? metadata}) {
    log(LogLevel.debug, message, url: url, metadata: metadata);
  }

  void info(String message, {String? url, Map<String, dynamic>? metadata}) {
    log(LogLevel.info, message, url: url, metadata: metadata);
  }

  void warning(String message, {String? url, Map<String, dynamic>? metadata}) {
    log(LogLevel.warning, message, url: url, metadata: metadata);
  }

  void error(String message, {String? url, String? stackTrace, Map<String, dynamic>? metadata}) {
    log(LogLevel.error, message, url: url, stackTrace: stackTrace, metadata: metadata);
  }

  void critical(String message, {String? url, String? stackTrace, Map<String, dynamic>? metadata}) {
    log(LogLevel.critical, message, url: url, stackTrace: stackTrace, metadata: metadata);
  }

  void addPageIssue(String type, String description, String url, LogLevel severity, {Map<String, dynamic>? details}) {
    final issue = PageIssue(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      description: description,
      url: url,
      timestamp: DateTime.now(),
      severity: severity,
      details: details,
    );

    _pageIssues.add(issue);
    
    if (_autoCleanup && _pageIssues.length > _maxIssues) {
      _pageIssues.removeRange(0, _pageIssues.length - _maxIssues);
    }

    notifyListeners();
  }

  void detectPageIssues(String url, String content, {Map<String, dynamic>? metadata}) {
    final issues = <String, dynamic>{};
    
    // Check for common page issues
    if (content.contains('error') || content.contains('exception')) {
      issues['error_detected'] = 'Page contains error messages or exceptions';
    }
    
    if (content.contains('404') || content.contains('not found')) {
      issues['page_not_found'] = 'Page appears to be a 404 or not found error';
    }
    
    if (content.contains('access denied') || content.contains('forbidden')) {
      issues['access_denied'] = 'Page indicates access denied or forbidden';
    }
    
    if (content.contains('server error') || content.contains('500')) {
      issues['server_error'] = 'Page indicates a server error';
    }
    
    if (content.contains('timeout') || content.contains('timed out')) {
      issues['timeout'] = 'Page indicates a timeout error';
    }
    
    if (content.contains('ssl') || content.contains('certificate')) {
      issues['ssl_issue'] = 'Page may have SSL/certificate issues';
    }
    
    if (content.contains('javascript') && content.contains('disabled')) {
      issues['js_disabled'] = 'JavaScript appears to be disabled or blocked';
    }
    
    if (content.contains('blocked') || content.contains('blocked by')) {
      issues['content_blocked'] = 'Content appears to be blocked by security software';
    }

    // Add detected issues
    issues.forEach((type, description) {
      addPageIssue(
        type,
        description.toString(),
        url,
        LogLevel.warning,
        details: metadata,
      );
    });
  }

  List<LogEntry> getLogsByLevel(LogLevel level) {
    return _logs.where((log) => log.level == level).toList();
  }

  List<LogEntry> getLogsByUrl(String url) {
    return _logs.where((log) => log.url == url).toList();
  }

  List<PageIssue> getIssuesByType(String type) {
    return _pageIssues.where((issue) => issue.type == type).toList();
  }

  List<PageIssue> getIssuesByUrl(String url) {
    return _pageIssues.where((issue) => issue.url == url).toList();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  void clearPageIssues() {
    _pageIssues.clear();
    notifyListeners();
  }

  void clearLogsByLevel(LogLevel level) {
    _logs.removeWhere((log) => log.level == level);
    notifyListeners();
  }

  void clearLogsByUrl(String url) {
    _logs.removeWhere((log) => log.url == url);
    notifyListeners();
  }

  void clearIssuesByType(String type) {
    _pageIssues.removeWhere((issue) => issue.type == type);
    notifyListeners();
  }

  void clearIssuesByUrl(String url) {
    _pageIssues.removeWhere((issue) => issue.url == url);
    notifyListeners();
  }

  String getLogsAsText() {
    return _logs.map((log) => 
      '[${log.timestamp.toIso8601String()}] ${log.level.name.toUpperCase()}: ${log.message}${log.url != null ? ' (URL: ${log.url})' : ''}'
    ).join('\n');
  }

  String getIssuesAsText() {
    return _pageIssues.map((issue) => 
      '[${issue.timestamp.toIso8601String()}] ${issue.severity.name.toUpperCase()}: ${issue.type} - ${issue.description} (URL: ${issue.url})'
    ).join('\n');
  }
}
