class BrowserTab {
  final String id;
  String title;
  String url;
  String? favicon;

  BrowserTab({
    required this.id,
    required this.title,
    required this.url,
    this.favicon,
  });

  BrowserTab copyWith({
    String? title,
    String? url,
    String? favicon,
  }) {
    return BrowserTab(
      id: id,
      title: title ?? this.title,
      url: url ?? this.url,
      favicon: favicon ?? this.favicon,
    );
  }
} 