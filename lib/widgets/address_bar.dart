import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/providers/browser_provider.dart';
import 'package:halo_browser/providers/bookmarks_provider.dart';

class AddressBar extends StatefulWidget {
  const AddressBar({super.key});

  @override
  State<AddressBar> createState() => _AddressBarState();
}

class _AddressBarState extends State<AddressBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    if (text.isEmpty) {
      setState(() {
        _showSuggestions = false;
        _suggestions = [];
      });
      return;
    }

    // Get suggestions from bookmarks
    final bookmarks = context.read<BookmarksProvider>().bookmarks;
    final bookmarkSuggestions = bookmarks
        .where((b) =>
            b.title.toLowerCase().contains(text.toLowerCase()) ||
            b.url.toLowerCase().contains(text.toLowerCase()))
        .map((b) => b.url)
        .toList();

    // Add common search engines
    final searchEngines = [
      'https://www.google.com/search?q=$text',
      'https://www.bing.com/search?q=$text',
      'https://duckduckgo.com/?q=$text',
    ];

    setState(() {
      _suggestions = [...bookmarkSuggestions, ...searchEngines];
      _showSuggestions = true;
    });
  }

  void _navigateToUrl(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    context.read<BrowserProvider>().navigateToUrl(url);
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.read<BrowserProvider>().goBack(),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => context.read<BrowserProvider>().goForward(),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search or enter URL',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        _focusNode.requestFocus();
                      },
                    ),
                  ),
                  onSubmitted: _navigateToUrl,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<BrowserProvider>().reload(),
              ),
            ],
          ),
          if (_showSuggestions && _suggestions.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    leading: const Icon(Icons.search),
                    title: Text(suggestion),
                    onTap: () => _navigateToUrl(suggestion),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
} 