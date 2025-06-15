import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/stock.dart';
import '../../../domain/repositories/stock_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final StockRepository stockRepository;
  final List<Stock> defaultStocks;

  SearchBloc({required this.stockRepository, required this.defaultStocks})
    : super(SearchState.initial(defaultStocks)) {
    on<SearchQueryChanged>((event, emit) {
      final allStocks = stockRepository.getAllStocks();
      final results = event.query.isEmpty
          ? defaultStocks
          : allStocks
                .where(
                  (stock) =>
                      stock.code.toLowerCase().startsWith(
                        event.query.toLowerCase(),
                      ) ||
                      stock.name.toLowerCase().startsWith(
                        event.query.toLowerCase(),
                      ),
                )
                .toList();
      emit(state.copyWith(query: event.query, results: results));
    });

    on<ToggleStockSelection>((event, emit) {
      final selected = Set<String>.from(state.selectedCodes);
      if (selected.contains(event.stock.code)) {
        selected.remove(event.stock.code);
      } else {
        selected.add(event.stock.code);
      }
      emit(state.copyWith(selectedCodes: selected));
    });

    on<ClearSearchSelection>((event, emit) {
      emit(state.copyWith(selectedCodes: {}));
    });
  }
}
