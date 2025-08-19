class AIService {
  final String id;
  final String name;
  final String description;
  final String baseUrl;
  final String? apiKey;
  final bool isEnabled;
  final Map<String, dynamic> config;

  AIService({
    required this.id,
    required this.name,
    required this.description,
    required this.baseUrl,
    this.apiKey,
    this.isEnabled = true,
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
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      baseUrl: json['baseUrl'] as String,
      apiKey: json['apiKey'] as String?,
      isEnabled: json['isEnabled'] as bool? ?? true,
      config: Map<String, dynamic>.from(json['config'] ?? {}),
    );
  }
}
