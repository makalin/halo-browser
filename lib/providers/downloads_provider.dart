import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:halo_browser/models/download.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DownloadsProvider with ChangeNotifier {
  static const String _downloadsKey = 'downloads';
  List<Download> _downloads = [];
  late SharedPreferences _prefs;
  final Map<String, Future<void> Function()> _downloadTasks = {};
  final Map<String, Timer> _speedTimers = {};
  final Map<String, int> _lastBytesReceived = {};

  List<Download> get downloads => List.unmodifiable(_downloads);

  DownloadsProvider() {
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    _prefs = await SharedPreferences.getInstance();
    final downloadsJson = _prefs.getStringList(_downloadsKey) ?? [];
    _downloads = downloadsJson
        .map((json) => Download.fromJson(jsonDecode(json)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveDownloads() async {
    final downloadsJson = _downloads
        .map((download) => jsonEncode(download.toJson()))
        .toList();
    await _prefs.setStringList(_downloadsKey, downloadsJson);
  }

  void _startSpeedTracking(String id) {
    _lastBytesReceived[id] = 0;
    _speedTimers[id] = Timer.periodic(const Duration(seconds: 1), (timer) {
      final index = _downloads.indexWhere((d) => d.id == id);
      if (index != -1) {
        final download = _downloads[index];
        final currentBytes = download.downloadedBytes;
        final lastBytes = _lastBytesReceived[id] ?? 0;
        final speed = currentBytes - lastBytes;
        _lastBytesReceived[id] = currentBytes;

        _downloads[index] = download.copyWith(downloadSpeed: speed.toDouble());
        _saveDownloads();
        notifyListeners();
      }
    });
  }

  void _stopSpeedTracking(String id) {
    _speedTimers[id]?.cancel();
    _speedTimers.remove(id);
    _lastBytesReceived.remove(id);
  }

  Future<void> startDownload(String url, String fileName) async {
    final download = Download(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url,
      fileName: fileName,
      fileSize: 0,
      startTime: DateTime.now(),
      status: DownloadStatus.downloading,
    );

    _downloads.add(download);
    await _saveDownloads();
    notifyListeners();

    _startSpeedTracking(download.id);

    _downloadTasks[download.id] = () async {
      try {
        final downloadDir = await getDownloadsDirectory();
        if (downloadDir == null) throw Exception('Downloads directory not found');

        final file = File(path.join(downloadDir.path, fileName));
        final request = await HttpClient().getUrl(Uri.parse(url));
        final response = await request.close();
        final totalBytes = response.contentLength;
        var receivedBytes = 0;

        await response.listen(
          (List<int> chunk) {
            receivedBytes += chunk.length;
            final progress = totalBytes > 0 ? receivedBytes / totalBytes : 0.0;
            _updateDownloadProgress(download.id, progress, receivedBytes);
          },
          onDone: () async {
            _stopSpeedTracking(download.id);
            await _updateDownloadStatus(
              download.id,
              DownloadStatus.completed,
            );
          },
          onError: (error) async {
            _stopSpeedTracking(download.id);
            await _updateDownloadStatus(
              download.id,
              DownloadStatus.failed,
              error: error.toString(),
            );
          },
        ).asFuture();
      } catch (e) {
        _stopSpeedTracking(download.id);
        await _updateDownloadStatus(
          download.id,
          DownloadStatus.failed,
          error: e.toString(),
        );
      }
    };

    _downloadTasks[download.id]?.call();
  }

  Future<void> _updateDownloadProgress(
    String id,
    double progress,
    int downloadedBytes,
  ) async {
    final index = _downloads.indexWhere((d) => d.id == id);
    if (index != -1) {
      _downloads[index] = _downloads[index].copyWith(
        progress: progress,
        downloadedBytes: downloadedBytes,
      );
      await _saveDownloads();
      notifyListeners();
    }
  }

  Future<void> _updateDownloadStatus(
    String id,
    DownloadStatus status, {
    String? error,
  }) async {
    final index = _downloads.indexWhere((d) => d.id == id);
    if (index != -1) {
      _downloads[index] = _downloads[index].copyWith(
        status: status,
        error: error,
      );
      await _saveDownloads();
      notifyListeners();
    }
  }

  Future<void> pauseDownload(Download download) async {
    _stopSpeedTracking(download.id);
    await _updateDownloadStatus(download.id, DownloadStatus.paused);
    _downloadTasks.remove(download.id);
  }

  Future<void> resumeDownload(Download download) async {
    _startSpeedTracking(download.id);
    await _updateDownloadStatus(download.id, DownloadStatus.downloading);
    _downloadTasks[download.id]?.call();
  }

  Future<void> retryDownload(Download download) async {
    _startSpeedTracking(download.id);
    await _updateDownloadStatus(download.id, DownloadStatus.downloading);
    _downloadTasks[download.id]?.call();
  }

  Future<void> openDownload(Download download) async {
    final downloadDir = await getDownloadsDirectory();
    if (downloadDir == null) return;

    final file = File(path.join(downloadDir.path, download.fileName));
    if (await file.exists()) {
      // TODO: Implement file opening based on platform
    }
  }

  Future<void> clearDownloads() async {
    for (final download in _downloads) {
      _stopSpeedTracking(download.id);
    }
    _downloads.clear();
    await _saveDownloads();
    notifyListeners();
  }

  @override
  void dispose() {
    for (final timer in _speedTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }
} 