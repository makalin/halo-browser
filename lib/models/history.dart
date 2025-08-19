class HistoryEntry {
  final String id;
  final String url;
  final String title;
  final DateTime timestamp;
  final int visitCount;
  final String? favicon;

  HistoryEntry({
    required this.id,
    required this.url,
    required this.title,
    required this.timestamp,
    this.visitCount = 1,
    this.favicon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'visitCount': visitCount,
      'favicon': favicon,
    };
  }

  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      id: map['id'],
      url: map['url'],
      title: map['title'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      visitCount: map['visitCount'] ?? 1,
      favicon: map['favicon'],
    );
  }

  HistoryEntry copyWith({
    String? id,
    String? url,
    String? title,
    DateTime? timestamp,
    int? visitCount,
    String? favicon,
  }) {
    return HistoryEntry(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      visitCount: visitCount ?? this.visitCount,
      favicon: favicon ?? this.favicon,
    );
  }
}
