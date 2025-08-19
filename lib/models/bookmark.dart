class Bookmark {
  final String id;
  final String title;
  final String url;
  final String? favicon;
  final DateTime dateAdded;

  Bookmark({
    required this.id,
    required this.title,
    required this.url,
    this.favicon,
    required this.dateAdded,
  });

  Bookmark copyWith({
    String? id,
    String? title,
    String? url,
    String? favicon,
    DateTime? dateAdded,
  }) {
    return Bookmark(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      favicon: favicon ?? this.favicon,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'favicon': favicon,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String,
      url: json['url'] as String,
      favicon: json['favicon'] as String?,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
    );
  }
} 