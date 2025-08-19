import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Script {
  final String id;
  final String name;
  final String description;
  final String code;
  final String language;
  final List<String> tags;
  final bool isEnabled;
  final bool autoRun;
  final Map<String, dynamic> config;
  final DateTime createdAt;
  final DateTime lastModified;

  Script({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.language,
    this.tags = const [],
    this.isEnabled = true,
    this.autoRun = false,
    this.config = const {},
    required this.createdAt,
    required this.lastModified,
  });

  Script copyWith({
    String? id,
    String? name,
    String? description,
    String? code,
    String? language,
    List<String>? tags,
    bool? isEnabled,
    bool? autoRun,
    Map<String, dynamic>? config,
    DateTime? createdAt,
    DateTime? lastModified,
  }) {
    return Script(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      code: code ?? this.code,
      language: language ?? this.language,
      tags: tags ?? this.tags,
      isEnabled: isEnabled ?? this.isEnabled,
      autoRun: autoRun ?? this.autoRun,
      config: config ?? this.config,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'code': code,
      'language': language,
      'tags': tags,
      'isEnabled': isEnabled,
      'autoRun': autoRun,
      'config': config,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
    };
  }

  factory Script.fromJson(Map<String, dynamic> json) {
    return Script(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      code: json['code'] ?? '',
      language: json['language'] ?? 'javascript',
      tags: List<String>.from(json['tags'] ?? []),
      isEnabled: json['isEnabled'] ?? true,
      autoRun: json['autoRun'] ?? false,
      config: json['config'] ?? {},
      createdAt: DateTime.parse(json['createdAt']),
      lastModified: DateTime.parse(json['lastModified']),
    );
  }
}

class ScriptExecutionResult {
  final String scriptId;
  final bool success;
  final dynamic result;
  final String? error;
  final DateTime executedAt;
  final String url;
  final Map<String, dynamic> metadata;

  ScriptExecutionResult({
    required this.scriptId,
    required this.success,
    this.result,
    this.error,
    required this.executedAt,
    required this.url,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'scriptId': scriptId,
      'success': success,
      'result': result,
      'error': error,
      'executedAt': executedAt.toIso8601String(),
      'url': url,
      'metadata': metadata,
    };
  }
}

class ContentExtractionRule {
  final String id;
  final String name;
  final String selector;
  final String attribute;
  final String outputFormat;
  final bool isEnabled;
  final Map<String, dynamic> config;

  ContentExtractionRule({
    required this.id,
    required this.name,
    required this.selector,
    required this.attribute,
    this.outputFormat = 'text',
    this.isEnabled = true,
    this.config = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'selector': selector,
      'attribute': attribute,
      'outputFormat': outputFormat,
      'isEnabled': isEnabled,
      'config': config,
    };
  }

  factory ContentExtractionRule.fromJson(Map<String, dynamic> json) {
    return ContentExtractionRule(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      selector: json['selector'] ?? '',
      attribute: json['attribute'] ?? '',
      outputFormat: json['outputFormat'] ?? 'text',
      isEnabled: json['isEnabled'] ?? true,
      config: json['config'] ?? {},
    );
  }
}

class ScriptEngineProvider with ChangeNotifier {
  final List<Script> _scripts = [];
  final List<ScriptExecutionResult> _executionHistory = [];
  final List<ContentExtractionRule> _extractionRules = [];
  
  bool _isEnabled = true;
  bool _autoRunScripts = false;
  bool _saveExecutionHistory = true;
  int _maxHistorySize = 1000;

  List<Script> get scripts => _scripts;
  List<ScriptExecutionResult> get executionHistory => _executionHistory;
  List<ContentExtractionRule> get extractionRules => _extractionRules;
  bool get isEnabled => _isEnabled;
  bool get autoRunScripts => _autoRunScripts;
  bool get saveExecutionHistory => _saveExecutionHistory;

  ScriptEngineProvider() {
    _loadSettings();
    _loadScripts();
    _loadExtractionRules();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isEnabled = prefs.getBool('script_engine_enabled') ?? true;
      _autoRunScripts = prefs.getBool('script_auto_run') ?? false;
      _saveExecutionHistory = prefs.getBool('script_save_history') ?? true;
      _maxHistorySize = prefs.getInt('script_max_history') ?? 1000;
    } catch (e) {
      debugPrint('Failed to load script engine settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('script_engine_enabled', _isEnabled);
      await prefs.setBool('script_auto_run', _autoRunScripts);
      await prefs.setBool('script_save_history', _saveExecutionHistory);
      await prefs.setInt('script_max_history', _maxHistorySize);
    } catch (e) {
      debugPrint('Failed to save script engine settings: $e');
    }
  }

  Future<void> _loadScripts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scriptsJson = prefs.getString('saved_scripts');
      if (scriptsJson != null) {
        final scriptsList = jsonDecode(scriptsJson) as List;
        _scripts.clear();
        for (final scriptJson in scriptsList) {
          _scripts.add(Script.fromJson(scriptJson));
        }
      }
    } catch (e) {
      debugPrint('Failed to load scripts: $e');
    }
  }

  Future<void> _saveScripts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scriptsJson = jsonEncode(_scripts.map((s) => s.toJson()).toList());
      await prefs.setString('saved_scripts', scriptsJson);
    } catch (e) {
      debugPrint('Failed to save scripts: $e');
    }
  }

  Future<void> _loadExtractionRules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rulesJson = prefs.getString('extraction_rules');
      if (rulesJson != null) {
        final rulesList = jsonDecode(rulesJson) as List;
        _extractionRules.clear();
        for (final ruleJson in rulesList) {
          _extractionRules.add(ContentExtractionRule.fromJson(ruleJson));
        }
      }
    } catch (e) {
      debugPrint('Failed to load extraction rules: $e');
    }
  }

  Future<void> _saveExtractionRules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rulesJson = jsonEncode(_extractionRules.map((r) => r.toJson()).toList());
      await prefs.setString('extraction_rules', rulesJson);
    } catch (e) {
      debugPrint('Failed to save extraction rules: $e');
    }
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    _saveSettings();
    notifyListeners();
  }

  void setAutoRunScripts(bool enabled) {
    _autoRunScripts = enabled;
    _saveSettings();
    notifyListeners();
  }

  void setSaveExecutionHistory(bool enabled) {
    _saveExecutionHistory = enabled;
    _saveSettings();
    notifyListeners();
  }

  void setMaxHistorySize(int size) {
    _maxHistorySize = size;
    _saveSettings();
    notifyListeners();
  }

  void addScript(Script script) {
    _scripts.add(script);
    _saveScripts();
    notifyListeners();
  }

  void updateScript(Script script) {
    final index = _scripts.indexWhere((s) => s.id == script.id);
    if (index != -1) {
      _scripts[index] = script.copyWith(
        lastModified: DateTime.now(),
      );
      _saveScripts();
      notifyListeners();
    }
  }

  void deleteScript(String scriptId) {
    _scripts.removeWhere((s) => s.id == scriptId);
    _saveScripts();
    notifyListeners();
  }

  void toggleScript(String scriptId) {
    final index = _scripts.indexWhere((s) => s.id == scriptId);
    if (index != -1) {
      _scripts[index] = _scripts[index].copyWith(
        isEnabled: !_scripts[index].isEnabled,
        lastModified: DateTime.now(),
      );
      _saveScripts();
      notifyListeners();
    }
  }

  void addExtractionRule(ContentExtractionRule rule) {
    _extractionRules.add(rule);
    _saveExtractionRules();
    notifyListeners();
  }

  void updateExtractionRule(ContentExtractionRule rule) {
    final index = _extractionRules.indexWhere((r) => r.id == rule.id);
    if (index != -1) {
      _extractionRules[index] = rule;
      _saveExtractionRules();
      notifyListeners();
    }
  }

  void deleteExtractionRule(String ruleId) {
    _extractionRules.removeWhere((r) => r.id == ruleId);
    _saveExtractionRules();
    notifyListeners();
  }

  Future<ScriptExecutionResult> executeScript(Script script, String url, {Map<String, dynamic>? context}) async {
    if (!_isEnabled || !script.isEnabled) {
      return ScriptExecutionResult(
        scriptId: script.id,
        success: false,
        error: 'Script execution is disabled',
        executedAt: DateTime.now(),
        url: url,
      );
    }

    try {
      // This would integrate with a JavaScript engine or interpreter
      // For now, simulate execution
      final result = await _simulateScriptExecution(script, url, context);
      
      final executionResult = ScriptExecutionResult(
        scriptId: script.id,
        success: true,
        result: result,
        executedAt: DateTime.now(),
        url: url,
        metadata: context ?? {},
      );

      if (_saveExecutionHistory) {
        _executionHistory.add(executionResult);
        if (_executionHistory.length > _maxHistorySize) {
          _executionHistory.removeRange(0, _executionHistory.length - _maxHistorySize);
        }
      }

      notifyListeners();
      return executionResult;
    } catch (e) {
      final executionResult = ScriptExecutionResult(
        scriptId: script.id,
        success: false,
        error: e.toString(),
        executedAt: DateTime.now(),
        url: url,
        metadata: context ?? {},
      );

      if (_saveExecutionHistory) {
        _executionHistory.add(executionResult);
        if (_executionHistory.length > _maxHistorySize) {
          _executionHistory.removeRange(0, _executionHistory.length - _maxHistorySize);
        }
      }

      notifyListeners();
      return executionResult;
    }
  }

  Future<dynamic> _simulateScriptExecution(Script script, String url, Map<String, dynamic>? context) async {
    // Simulate different script types
    switch (script.language.toLowerCase()) {
      case 'javascript':
        return _executeJavaScript(script.code, url, context);
      case 'python':
        return _executePython(script.code, url, context);
      case 'regex':
        return _executeRegex(script.code, url, context);
      default:
        return 'Unsupported language: ${script.language}';
    }
  }

  Future<dynamic> _executeJavaScript(String code, String url, Map<String, dynamic>? context) async {
    // This would integrate with a JavaScript engine
    // For now, return simulated results
    if (code.contains('document.querySelector')) {
      return 'Simulated DOM query result for $url';
    } else if (code.contains('fetch')) {
      return 'Simulated network request result';
    } else if (code.contains('console.log')) {
      return 'Simulated console output';
    }
    return 'JavaScript executed successfully';
  }

  Future<dynamic> _executePython(String code, String url, Map<String, dynamic>? context) async {
    // This would integrate with a Python interpreter
    return 'Python script executed successfully';
  }

  Future<dynamic> _executeRegex(String pattern, String url, Map<String, dynamic>? context) async {
    // This would execute regex patterns
    return 'Regex pattern executed successfully';
  }

  Future<Map<String, dynamic>> extractContent(String url, String htmlContent) async {
    final results = <String, dynamic>{};
    
    for (final rule in _extractionRules) {
      if (rule.isEnabled) {
        try {
          final extracted = await _applyExtractionRule(rule, htmlContent);
          results[rule.name] = extracted;
        } catch (e) {
          results[rule.name] = 'Error: $e';
        }
      }
    }
    
    return results;
  }

  Future<dynamic> _applyExtractionRule(ContentExtractionRule rule, String htmlContent) async {
    // This would apply the extraction rule to HTML content
    // For now, return simulated extraction
    switch (rule.outputFormat) {
      case 'text':
        return 'Extracted text content using ${rule.selector}';
      case 'image':
        return 'Extracted image URLs using ${rule.selector}';
      case 'link':
        return 'Extracted links using ${rule.selector}';
      case 'json':
        return {'extracted': 'data', 'selector': rule.selector};
      default:
        return 'Extracted content using ${rule.selector}';
    }
  }

  List<Script> getScriptsByTag(String tag) {
    return _scripts.where((script) => script.tags.contains(tag)).toList();
  }

  List<Script> getScriptsByLanguage(String language) {
    return _scripts.where((script) => script.language.toLowerCase() == language.toLowerCase()).toList();
  }

  List<ScriptExecutionResult> getExecutionHistoryByScript(String scriptId) {
    return _executionHistory.where((result) => result.scriptId == scriptId).toList();
  }

  List<ScriptExecutionResult> getExecutionHistoryByUrl(String url) {
    return _executionHistory.where((result) => result.url == url).toList();
  }

  void clearExecutionHistory() {
    _executionHistory.clear();
    notifyListeners();
  }

  void clearExecutionHistoryByScript(String scriptId) {
    _executionHistory.removeWhere((result) => result.scriptId == scriptId);
    notifyListeners();
  }

  void clearExecutionHistoryByUrl(String url) {
    _executionHistory.removeWhere((result) => result.url == url);
    notifyListeners();
  }

  String exportScripts() {
    return jsonEncode(_scripts.map((s) => s.toJson()).toList());
  }

  void importScripts(String jsonData) {
    try {
      final scriptsList = jsonDecode(jsonData) as List;
      _scripts.clear();
      for (final scriptJson in scriptsList) {
        _scripts.add(Script.fromJson(scriptJson));
      }
      _saveScripts();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to import scripts: $e');
    }
  }

  String exportExtractionRules() {
    return jsonEncode(_extractionRules.map((r) => r.toJson()).toList());
  }

  void importExtractionRules(String jsonData) {
    try {
      final rulesList = jsonDecode(jsonData) as List;
      _extractionRules.clear();
      for (final ruleJson in rulesList) {
        _extractionRules.add(ContentExtractionRule.fromJson(ruleJson));
      }
      _saveExtractionRules();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to import extraction rules: $e');
    }
  }
}
