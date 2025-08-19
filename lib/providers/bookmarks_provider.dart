import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:halo_browser/models/bookmark.dart';

class BookmarksProvider with ChangeNotifier {
  static const String _bookmarksKey = 'bookmarks';
  List<Bookmark> _bookmarks = [];
  late SharedPreferences _prefs;

  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);

  BookmarksProvider() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    _prefs = await SharedPreferences.getInstance();
    final bookmarksJson = _prefs.getStringList(_bookmarksKey) ?? [];
    _bookmarks = bookmarksJson
        .map((json) => Bookmark.fromJson(jsonDecode(json)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveBookmarks() async {
    final bookmarksJson = _bookmarks
        .map((bookmark) => jsonEncode(bookmark.toJson()))
        .toList();
    await _prefs.setStringList(_bookmarksKey, bookmarksJson);
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    _bookmarks.add(bookmark);
    await _saveBookmarks();
    notifyListeners();
  }

  Future<void> removeBookmark(Bookmark bookmark) async {
    _bookmarks.removeWhere((b) => b.url == bookmark.url);
    await _saveBookmarks();
    notifyListeners();
  }

  Future<void> updateBookmark(Bookmark oldBookmark, Bookmark newBookmark) async {
    final index = _bookmarks.indexWhere((b) => b.url == oldBookmark.url);
    if (index != -1) {
      _bookmarks[index] = newBookmark;
      await _saveBookmarks();
      notifyListeners();
    }
  }

  void openBookmark(Bookmark bookmark) {
    // TODO: Implement opening bookmark in a new tab
  }

  List<Bookmark> searchBookmarks(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _bookmarks.where((bookmark) {
      return bookmark.title.toLowerCase().contains(lowercaseQuery) ||
          bookmark.url.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
} 