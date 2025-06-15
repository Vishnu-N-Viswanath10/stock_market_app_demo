import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/stock_model.dart';

class WatchlistLocalDataSource {
  static const String _key = 'watchlists_data';

  Future<void> saveWatchlists(
    List<String> groupNames,
    List<List<StockModel>> watchlists,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'groupNames': groupNames,
      'watchlists': watchlists
          .map((list) => list.map((s) => s.toJson()).toList())
          .toList(),
    };
    await prefs.setString(_key, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> loadWatchlists() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }
}
