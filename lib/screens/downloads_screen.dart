import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/providers/downloads_provider.dart';
import 'package:halo_browser/models/download.dart';
import 'package:path/path.dart' as path;

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Downloads'),
                  content: const Text('Are you sure you want to clear all downloads?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<DownloadsProvider>().clearDownloads();
                        Navigator.pop(context);
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<DownloadsProvider>(
        builder: (context, provider, child) {
          if (provider.downloads.isEmpty) {
            return const Center(
              child: Text('No downloads yet'),
            );
          }

          return ListView.builder(
            itemCount: provider.downloads.length,
            itemBuilder: (context, index) {
              final download = provider.downloads[index];
              return _DownloadItem(download: download);
            },
          );
        },
      ),
    );
  }
}

class _DownloadItem extends StatelessWidget {
  final Download download;

  const _DownloadItem({required this.download});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _getFileIcon(download.fileName),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        download.fileName,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Size: ${_formatFileSize(download.fileSize)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _buildTrailingWidget(context),
              ],
            ),
            if (download.status == DownloadStatus.downloading) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: download.progress,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_formatFileSize(download.downloadedBytes)} / ${_formatFileSize(download.fileSize)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${_formatFileSize(download.downloadSpeed.toInt())}/s',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
            if (download.status == DownloadStatus.failed)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  download.error ?? 'Download failed',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getFileIcon(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    IconData iconData;

    switch (extension) {
      case '.pdf':
        iconData = Icons.picture_as_pdf;
        break;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        iconData = Icons.image;
        break;
      case '.mp3':
      case '.wav':
        iconData = Icons.audio_file;
        break;
      case '.mp4':
      case '.avi':
      case '.mov':
        iconData = Icons.video_file;
        break;
      default:
        iconData = Icons.insert_drive_file;
    }

    return Icon(iconData, size: 32);
  }

  Widget _buildTrailingWidget(BuildContext context) {
    switch (download.status) {
      case DownloadStatus.downloading:
        return IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () {
            context.read<DownloadsProvider>().pauseDownload(download);
          },
        );
      case DownloadStatus.paused:
        return IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () {
            context.read<DownloadsProvider>().resumeDownload(download);
          },
        );
      case DownloadStatus.completed:
        return IconButton(
          icon: const Icon(Icons.folder_open),
          onPressed: () {
            context.read<DownloadsProvider>().openDownload(download);
          },
        );
      case DownloadStatus.failed:
        return IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<DownloadsProvider>().retryDownload(download);
          },
        );
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
} 