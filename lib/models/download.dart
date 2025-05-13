enum DownloadStatus {
  downloading,
  paused,
  completed,
  failed,
}

class Download {
  final String id;
  final String url;
  final String fileName;
  final int fileSize;
  final DateTime startTime;
  final DownloadStatus status;
  final double progress;
  final String? error;
  final double downloadSpeed; // Bytes per second
  final int downloadedBytes;

  Download({
    required this.id,
    required this.url,
    required this.fileName,
    required this.fileSize,
    required this.startTime,
    required this.status,
    this.progress = 0.0,
    this.error,
    this.downloadSpeed = 0.0,
    this.downloadedBytes = 0,
  });

  Download copyWith({
    String? id,
    String? url,
    String? fileName,
    int? fileSize,
    DateTime? startTime,
    DownloadStatus? status,
    double? progress,
    String? error,
    double? downloadSpeed,
    int? downloadedBytes,
  }) {
    return Download(
      id: id ?? this.id,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      startTime: startTime ?? this.startTime,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      error: error ?? this.error,
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'fileName': fileName,
      'fileSize': fileSize,
      'startTime': startTime.toIso8601String(),
      'status': status.toString(),
      'progress': progress,
      'error': error,
      'downloadSpeed': downloadSpeed,
      'downloadedBytes': downloadedBytes,
    };
  }

  factory Download.fromJson(Map<String, dynamic> json) {
    return Download(
      id: json['id'] as String,
      url: json['url'] as String,
      fileName: json['fileName'] as String,
      fileSize: json['fileSize'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      status: DownloadStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      progress: json['progress'] as double,
      error: json['error'] as String?,
      downloadSpeed: json['downloadSpeed'] as double? ?? 0.0,
      downloadedBytes: json['downloadedBytes'] as int? ?? 0,
    );
  }
} 