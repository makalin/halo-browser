enum LogLevel { debug, info, warning, error, critical }

class LogEntry {
  final String id;
  final LogLevel level;
  final String message;
  final String? url;
  final String? stackTrace;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  LogEntry({
    required this.id,
    required this.level,
    required this.message,
    this.url,
    this.stackTrace,
    required this.timestamp,
    this.metadata = const {},
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
      id: json['id'] as String,
      level: LogLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => LogLevel.info,
      ),
      message: json['message'] as String,
      url: json['url'] as String?,
      stackTrace: json['stackTrace'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

class PageIssue {
  final String id;
  final String type;
  final String description;
  final String url;
  final DateTime timestamp;
  final String severity;
  final Map<String, dynamic> details;

  PageIssue({
    required this.id,
    required this.type,
    required this.description,
    required this.url,
    required this.timestamp,
    this.severity = 'medium',
    this.details = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'url': url,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity,
      'details': details,
    };
  }

  factory PageIssue.fromJson(Map<String, dynamic> json) {
    return PageIssue(
      id: json['id'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      severity: json['severity'] as String? ?? 'medium',
      details: Map<String, dynamic>.from(json['details'] ?? {}),
    );
  }
}
