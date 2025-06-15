import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/stock_model.dart';

class MockStockDataSource {
  Future<List<StockModel>> getAllStocks() async {
    final String jsonString = await rootBundle.loadString('assets/stock.json');
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => StockModel.fromJson(e)).toList();
  }
}
