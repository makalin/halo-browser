import 'package:flutter/foundation.dart';
import 'package:halo_browser/models/history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HistoryProvider with ChangeNotifier {
  List<HistoryEntry> _history = [];
  Database? _database;
  bool _isInitialized = false;

  List<HistoryEntry> get history => _history;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _initDatabase();
    await _loadHistory();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'halo_browser.db');
    
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history (
            id TEXT PRIMARY KEY,
            url TEXT NOT NULL,
            title TEXT NOT NULL,
            timestamp INTEGER NOT NULL,
            visitCount INTEGER NOT NULL,
            favicon TEXT
          )
        ''');
        
        await db.execute('CREATE INDEX idx_history_url ON history(url)');
        await db.execute('CREATE INDEX idx_history_timestamp ON history(timestamp)');
      },
    );
  }

  Future<void> _loadHistory() async {
    if (_database == null) return;
    
    final List<Map<String, dynamic>> maps = await _database!.query(
      'history',
      orderBy: 'timestamp DESC',
      limit: 1000,
    );
    
    _history = maps.map((map) => HistoryEntry.fromMap(map)).toList();
  }

  Future<void> addHistoryEntry(String url, String title, {String? favicon}) async {
    if (_database == null) return;

    final existingEntry = _history.firstWhere(
      (entry) => entry.url == url,
      orElse: () => HistoryEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        url: url,
        title: title,
        timestamp: DateTime.now(),
        visitCount: 0,
        favicon: favicon,
      ),
    );

    if (existingEntry.id != DateTime.now().millisecondsSinceEpoch.toString()) {
      // Update existing entry
      final updatedEntry = existingEntry.copyWith(
        title: title,
        timestamp: DateTime.now(),
        visitCount: existingEntry.visitCount + 1,
        favicon: favicon ?? existingEntry.favicon,
      );
      
      await _database!.update(
        'history',
        updatedEntry.toMap(),
        where: 'id = ?',
        whereArgs: [existingEntry.id],
      );
      
      final index = _history.indexWhere((entry) => entry.id == existingEntry.id);
      if (index != -1) {
        _history[index] = updatedEntry;
      }
    } else {
      // Add new entry
      await _database!.insert('history', existingEntry.toMap());
      _history.insert(0, existingEntry);
    }
    
    notifyListeners();
  }

  Future<void> removeHistoryEntry(String id) async {
    if (_database == null) return;
    
    await _database!.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    _history.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    if (_database == null) return;
    
    await _database!.delete('history');
    _history.clear();
    notifyListeners();
  }

  Future<void> clearHistoryOlderThan(Duration age) async {
    if (_database == null) return;
    
    final cutoff = DateTime.now().subtract(age).millisecondsSinceEpoch;
    
    await _database!.delete(
      'history',
      where: 'timestamp < ?',
      whereArgs: [cutoff],
    );
    
    _history.removeWhere((entry) => entry.timestamp.millisecondsSinceEpoch < cutoff);
    notifyListeners();
  }

  List<HistoryEntry> searchHistory(String query) {
    if (query.isEmpty) return _history;
    
    final lowercaseQuery = query.toLowerCase();
    return _history.where((entry) {
      return entry.title.toLowerCase().contains(lowercaseQuery) ||
             entry.url.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  List<HistoryEntry> getHistoryForUrl(String url) {
    return _history.where((entry) => entry.url == url).toList();
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }
}
