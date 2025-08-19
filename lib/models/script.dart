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
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      code: json['code'] as String,
      language: json['language'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      isEnabled: json['isEnabled'] as bool? ?? true,
      autoRun: json['autoRun'] as bool? ?? false,
      config: Map<String, dynamic>.from(json['config'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
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
  final String? attribute;
  final String outputFormat;
  final bool isEnabled;
  final Map<String, dynamic> config;

  ContentExtractionRule({
    required this.id,
    required this.name,
    required this.selector,
    this.attribute,
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
      id: json['id'] as String,
      name: json['name'] as String,
      selector: json['selector'] as String,
      attribute: json['attribute'] as String?,
      outputFormat: json['outputFormat'] as String? ?? 'text',
      isEnabled: json['isEnabled'] as bool? ?? true,
      config: Map<String, dynamic>.from(json['config'] ?? {}),
    );
  }
}
