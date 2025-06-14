import '../entities/stock.dart';
import '../repositories/stock_repository.dart';

class GetStocks {
  final StockRepository repository;

  GetStocks(this.repository);

  List<Stock> call() {
    return repository.getAllStocks();
  }
}