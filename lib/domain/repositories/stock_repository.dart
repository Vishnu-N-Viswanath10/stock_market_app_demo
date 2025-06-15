import '../entities/stock.dart';

abstract class StockRepository {
  Future<List<Stock>> getAllStocks();
}
