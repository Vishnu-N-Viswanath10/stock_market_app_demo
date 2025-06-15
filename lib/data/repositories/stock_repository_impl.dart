import '../../domain/entities/stock.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/mock_stock_data_source.dart';

class StockRepositoryImpl implements StockRepository {
  final MockStockDataSource dataSource;

  StockRepositoryImpl(this.dataSource);

  @override
  List<Stock> getAllStocks() {
    return dataSource.getAllStocks();
  }
}
