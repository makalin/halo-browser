class Bookmark {
  final String title;
  final String url;
  final String? favicon;
  final DateTime dateAdded;

  Bookmark({
    required this.title,
    required this.url,
    this.favicon,
    required this.dateAdded,
  });

  Bookmark copyWith({
    String? title,
    String? url,
    String? favicon,
    DateTime? dateAdded,
  }) {
    return Bookmark(
      title: title ?? this.title,
      url: url ?? this.url,
      favicon: favicon ?? this.favicon,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'favicon': favicon,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      title: json['title'] as String,
      url: json['url'] as String,
      favicon: json['favicon'] as String?,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
    );
  }
} 