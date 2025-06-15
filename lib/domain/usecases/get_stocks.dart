import '../entities/stock.dart';
import '../repositories/stock_repository.dart';

class GetStocks {
  final StockRepository repository;
  GetStocks(this.repository);

  Future<List<Stock>> call() {
    return repository.getAllStocks();
  }
}
