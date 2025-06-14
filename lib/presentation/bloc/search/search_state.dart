import '../../../domain/entities/stock.dart';

class SearchState {
  final String query;
  final List<Stock> results;
  final Set<String> selectedCodes;

  SearchState({
    required this.query,
    required this.results,
    required this.selectedCodes,
  });

  factory SearchState.initial(List<Stock> defaultStocks) => SearchState(
        query: '',
        results: defaultStocks,
        selectedCodes: {},
      );

  SearchState copyWith({
    String? query,
    List<Stock>? results,
    Set<String>? selectedCodes,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      selectedCodes: selectedCodes ?? this.selectedCodes,
    );
  }
}