import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistProvider extends ChangeNotifier {
  Set<String> _watchlist = {};
  bool _loaded = false;

  Set<String> get watchlist => _watchlist;
  bool get isLoaded => _loaded;

  WatchlistProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('watchlist') ?? ['BTC', 'ETH', 'AAPL'];
    _watchlist = saved.toSet();
    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('watchlist', _watchlist.toList());
  }

  bool isWatching(String symbol) => _watchlist.contains(symbol);

  Future<void> toggle(String symbol) async {
    if (_watchlist.contains(symbol)) {
      _watchlist.remove(symbol);
    } else {
      _watchlist.add(symbol);
    }
    notifyListeners();
    await _save();
  }

  Future<void> remove(String symbol) async {
    _watchlist.remove(symbol);
    notifyListeners();
    await _save();
  }
}
