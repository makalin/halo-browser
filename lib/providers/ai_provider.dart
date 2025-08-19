import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AIService {
  final String id;
  final String name;
  final String description;
  final String baseUrl;
  final String apiKey;
  final bool isEnabled;
  final Map<String, dynamic> config;

  AIService({
    required this.id,
    required this.name,
    required this.description,
    required this.baseUrl,
    required this.apiKey,
    this.isEnabled = false,
    this.config = const {},
  });

  AIService copyWith({
    String? id,
    String? name,
    String? description,
    String? baseUrl,
    String? apiKey,
    bool? isEnabled,
    Map<String, dynamic>? config,
  }) {
    return AIService(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      isEnabled: isEnabled ?? this.isEnabled,
      config: config ?? this.config,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'baseUrl': baseUrl,
      'apiKey': apiKey,
      'isEnabled': isEnabled,
      'config': config,
    };
  }

  factory AIService.fromJson(Map<String, dynamic> json) {
    return AIService(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      baseUrl: json['baseUrl'] ?? '',
      apiKey: json['apiKey'] ?? '',
      isEnabled: json['isEnabled'] ?? false,
      config: json['config'] ?? {},
    );
  }
}

class AIProvider with ChangeNotifier {
  final List<AIService> _services = [];
  AIService? _defaultService;
  bool _isEnabled = false;
  bool _autoAnalyzePages = false;
  bool _showAISuggestions = true;

  List<AIService> get services => _services;
  AIService? get defaultService => _defaultService;
  bool get isEnabled => _isEnabled;
  bool get autoAnalyzePages => _autoAnalyzePages;
  bool get showAISuggestions => _showAISuggestions;

  AIProvider() {
    _initializeDefaultServices();
    _loadSettings();
  }

  void _initializeDefaultServices() {
    _services.addAll([
      AIService(
        id: 'chatgpt',
        name: 'ChatGPT',
        description: 'OpenAI\'s ChatGPT for intelligent assistance',
        baseUrl: 'https://api.openai.com/v1',
        apiKey: '',
        isEnabled: false,
        config: {
          'model': 'gpt-4',
          'maxTokens': 1000,
          'temperature': 0.7,
        },
      ),
      AIService(
        id: 'grok',
        name: 'Grok',
        description: 'xAI\'s Grok for real-time information',
        baseUrl: 'https://api.x.ai/v1',
        apiKey: '',
        isEnabled: false,
        config: {
          'model': 'grok-beta',
          'maxTokens': 1000,
          'temperature': 0.7,
        },
      ),
      AIService(
        id: 'ollama',
        name: 'Ollama',
        description: 'Local AI models for privacy-focused assistance',
        baseUrl: 'http://localhost:11434',
        apiKey: '',
        isEnabled: false,
        config: {
          'model': 'llama2',
          'maxTokens': 1000,
          'temperature': 0.7,
        },
      ),
      AIService(
        id: 'claude',
        name: 'Claude',
        description: 'Anthropic\'s Claude for safe AI assistance',
        baseUrl: 'https://api.anthropic.com/v1',
        apiKey: '',
        isEnabled: false,
        config: {
          'model': 'claude-3-sonnet',
          'maxTokens': 1000,
          'temperature': 0.7,
        },
      ),
    ]);
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isEnabled = prefs.getBool('ai_enabled') ?? false;
      _autoAnalyzePages = prefs.getBool('ai_auto_analyze') ?? false;
      _showAISuggestions = prefs.getBool('ai_show_suggestions') ?? true;
      
      final defaultServiceId = prefs.getString('ai_default_service');
      if (defaultServiceId != null) {
        _defaultService = _services.firstWhere(
          (service) => service.id == defaultServiceId,
          orElse: () => _services.first,
        );
      }

      // Load service configurations
      for (int i = 0; i < _services.length; i++) {
        final serviceId = _services[i].id;
        final serviceData = prefs.getString('ai_service_$serviceId');
        if (serviceData != null) {
          try {
            final serviceJson = Map<String, dynamic>.from(
              serviceData.split(',').asMap().map((k, v) => MapEntry(k.toString(), v)),
            );
            _services[i] = _services[i].copyWith(
              apiKey: serviceJson['apiKey'] ?? '',
              isEnabled: serviceJson['isEnabled'] ?? false,
              config: serviceJson['config'] ?? {},
            );
          } catch (e) {
            debugPrint('Failed to load AI service config: $e');
          }
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load AI settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('ai_enabled', _isEnabled);
      await prefs.setBool('ai_auto_analyze', _autoAnalyzePages);
      await prefs.setBool('ai_show_suggestions', _showAISuggestions);
      
      if (_defaultService != null) {
        await prefs.setString('ai_default_service', _defaultService!.id);
      }

      // Save service configurations
      for (final service in _services) {
        final serviceData = [
          service.apiKey,
          service.isEnabled.toString(),
          service.config.toString(),
        ].join(',');
        await prefs.setString('ai_service_${service.id}', serviceData);
      }
    } catch (e) {
      debugPrint('Failed to save AI settings: $e');
    }
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    _saveSettings();
    notifyListeners();
  }

  void setAutoAnalyzePages(bool enabled) {
    _autoAnalyzePages = enabled;
    _saveSettings();
    notifyListeners();
  }

  void setShowAISuggestions(bool enabled) {
    _showAISuggestions = enabled;
    _saveSettings();
    notifyListeners();
  }

  void setDefaultService(String serviceId) {
    _defaultService = _services.firstWhere(
      (service) => service.id == serviceId,
      orElse: () => _services.first,
    );
    _saveSettings();
    notifyListeners();
  }

  void updateService(String serviceId, AIService updatedService) {
    final index = _services.indexWhere((service) => service.id == serviceId);
    if (index != -1) {
      _services[index] = updatedService;
      _saveSettings();
      notifyListeners();
    }
  }

  Future<String> analyzePageContent(String url, String content) async {
    if (!_isEnabled || _defaultService == null || !_defaultService!.isEnabled) {
      return 'AI analysis is not available. Please enable an AI service in settings.';
    }

    try {
      // This would integrate with the actual AI service APIs
      // For now, return a placeholder response
      return 'AI analysis of $url:\n\nThis page appears to be ${content.length > 1000 ? 'content-rich' : 'brief'} and contains ${content.split(' ').length} words. Based on the content structure, it appears to be a ${_detectContentType(content)}.';
    } catch (e) {
      return 'Failed to analyze page: $e';
    }
  }

  String _detectContentType(String content) {
    if (content.contains('<!DOCTYPE html>') || content.contains('<html')) {
      return 'web page';
    } else if (content.contains('function') || content.contains('const ') || content.contains('var ')) {
      return 'code/documentation';
    } else if (content.contains('error') || content.contains('exception')) {
      return 'error log or technical document';
    } else {
      return 'text document';
    }
  }

  Future<String> getAISuggestion(String context, String query) async {
    if (!_isEnabled || _defaultService == null || !_defaultService!.isEnabled) {
      return '';
    }

    try {
      // This would integrate with the actual AI service APIs
      // For now, return contextual suggestions
      if (query.toLowerCase().contains('error')) {
        return 'Try checking the browser console for more detailed error information.';
      } else if (query.toLowerCase().contains('slow')) {
        return 'Consider enabling page caching or checking your internet connection.';
      } else if (query.toLowerCase().contains('security')) {
        return 'Verify the website\'s SSL certificate and check for any security warnings.';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  List<String> getAvailableModels(String serviceId) {
    final service = _services.firstWhere(
      (service) => service.id == serviceId,
      orElse: () => AIService(id: '', name: '', description: '', baseUrl: '', apiKey: ''),
    );

    switch (serviceId) {
      case 'chatgpt':
        return ['gpt-4', 'gpt-4-turbo', 'gpt-3.5-turbo'];
      case 'grok':
        return ['grok-beta', 'grok-pro'];
      case 'ollama':
        return ['llama2', 'codellama', 'mistral', 'neural-chat'];
      case 'claude':
        return ['claude-3-opus', 'claude-3-sonnet', 'claude-3-haiku'];
      default:
        return [];
    }
  }
}
