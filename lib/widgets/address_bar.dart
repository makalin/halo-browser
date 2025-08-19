import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/providers/browser_provider.dart';
import 'package:halo_browser/providers/history_provider.dart';
import 'package:halo_browser/providers/bookmarks_provider.dart';

class AddressBar extends StatefulWidget {
  const AddressBar({super.key});

  @override
  State<AddressBar> createState() => _AddressBarState();
}

class _AddressBarState extends State<AddressBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isEditing = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateControllerFromProvider() {
    final provider = context.read<BrowserProvider>();
    if (provider.currentTab != null && 
        _controller.text != provider.currentTab!.url) {
      _controller.text = provider.currentTab!.url;
    }
  }

  void _navigateToUrl() {
    final url = _controller.text.trim();
    if (url.isNotEmpty) {
      String processedUrl = url;
      
      // Add https:// if no protocol specified
      if (!url.startsWith('http://') && !url.startsWith('https://') && !url.startsWith('about:')) {
        processedUrl = 'https://$url';
      }
      
      context.read<BrowserProvider>().navigateToUrl(processedUrl);
      _focusNode.unfocus();
    }
  }

  void _showUrlSuggestions() {
    final historyProvider = context.read<HistoryProvider>();
    final bookmarksProvider = context.read<BookmarksProvider>();
    
    showModalBottomSheet(
      context: context,
      builder: (context) => _UrlSuggestionsSheet(
        query: _controller.text,
        historyProvider: historyProvider,
        bookmarksProvider: bookmarksProvider,
        onUrlSelected: (url) {
          _controller.text = url;
          _navigateToUrl();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrowserProvider>(
      builder: (context, provider, child) {
        _updateControllerFromProvider();
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Navigation buttons
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: provider.canGoBack 
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
                onPressed: provider.canGoBack ? provider.goBack : null,
                tooltip: 'Go back',
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: provider.canGoForward 
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
                onPressed: provider.canGoForward ? provider.goForward : null,
                tooltip: 'Go forward',
              ),
              IconButton(
                icon: Icon(
                  provider.isLoading ? Icons.stop : Icons.refresh,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: provider.reload,
                tooltip: provider.isLoading ? 'Stop loading' : 'Refresh',
              ),
              
              const SizedBox(width: 8),
              
              // Address bar
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isEditing 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Search or enter address',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      suffixIcon: _isEditing ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _focusNode.requestFocus();
                        },
                      ) : null,
                    ),
                    onSubmitted: (_) => _navigateToUrl(),
                    onTap: _showUrlSuggestions,
                    textInputAction: TextInputAction.go,
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Bookmark button
              Consumer<BookmarksProvider>(
                builder: (context, bookmarksProvider, child) {
                  final currentUrl = provider.currentTab?.url;
                  final isBookmarked = currentUrl != null && 
                    bookmarksProvider.bookmarks.any((b) => b.url == currentUrl);
                  
                  return IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      if (currentUrl != null) {
                        if (isBookmarked) {
                          final bookmark = bookmarksProvider.bookmarks
                            .firstWhere((b) => b.url == currentUrl);
                          bookmarksProvider.removeBookmark(bookmark.id);
                        } else {
                          bookmarksProvider.addBookmark(
                            title: provider.currentTab?.title ?? 'Untitled',
                            url: currentUrl,
                          );
                        }
                      }
                    },
                    tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UrlSuggestionsSheet extends StatelessWidget {
  final String query;
  final HistoryProvider historyProvider;
  final BookmarksProvider bookmarksProvider;
  final Function(String) onUrlSelected;

  const _UrlSuggestionsSheet({
    required this.query,
    required this.historyProvider,
    required this.bookmarksProvider,
    required this.onUrlSelected,
  });

  @override
  Widget build(BuildContext context) {
    final historyResults = historyProvider.searchHistory(query);
    final bookmarkResults = bookmarksProvider.searchBookmarks(query);
    
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggestions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                if (bookmarkResults.isNotEmpty) ...[
                  _buildSectionHeader(context, 'Bookmarks'),
                  ...bookmarkResults.map((bookmark) => _buildSuggestionTile(
                    context,
                    bookmark.title,
                    bookmark.url,
                    Icons.bookmark,
                    () => onUrlSelected(bookmark.url),
                  )),
                  const Divider(),
                ],
                if (historyResults.isNotEmpty) ...[
                  _buildSectionHeader(context, 'History'),
                  ...historyResults.take(5).map((entry) => _buildSuggestionTile(
                    context,
                    entry.title,
                    entry.url,
                    Icons.history,
                    () => onUrlSelected(entry.url),
                  )),
                ],
                if (bookmarkResults.isEmpty && historyResults.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No suggestions found',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSuggestionTile(
    BuildContext context,
    String title,
    String url,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        url,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: onTap,
      dense: true,
    );
  }
} 