import '../../../domain/entities/stock.dart';

abstract class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class ToggleStockSelection extends SearchEvent {
  final Stock stock;
  ToggleStockSelection(this.stock);
}

class ClearSearchSelection extends SearchEvent {}

class AddSelectedToWatchlist extends SearchEvent {
  final int watchlistIndex;
  AddSelectedToWatchlist(this.watchlistIndex);
}