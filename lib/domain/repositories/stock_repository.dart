import '../entities/stock.dart';

abstract class StockRepository {
  List<Stock> getAllStocks();
}