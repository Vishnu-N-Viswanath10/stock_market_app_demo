import '../../domain/entities/stock.dart';

abstract class WatchlistEvent {}

class LoadWatchlistsFromStorage extends WatchlistEvent {}

class SwitchWatchlistGroup extends WatchlistEvent {
  final int groupIndex;
  SwitchWatchlistGroup(this.groupIndex);
}

class AddStockToWatchlist extends WatchlistEvent {
  final int groupIndex;
  final Stock stock;
  AddStockToWatchlist(this.groupIndex, this.stock);
}

class RemoveStockFromWatchlist extends WatchlistEvent {
  final int groupIndex;
  final Stock stock;
  RemoveStockFromWatchlist(this.groupIndex, this.stock);
}

class RearrangeStocksInWatchlist extends WatchlistEvent {
  final int groupIndex;
  final int oldIndex;
  final int newIndex;
  RearrangeStocksInWatchlist(this.groupIndex, this.oldIndex, this.newIndex);
}

class CreateNewWatchlistGroup extends WatchlistEvent {
  final String groupName;
  final Stock? initialStock;
  CreateNewWatchlistGroup(this.groupName, {this.initialStock});
}

class RenameWatchlist extends WatchlistEvent {
  final int index;
  final String newName;
  RenameWatchlist(this.index, this.newName);
}

class DeleteWatchlist extends WatchlistEvent {
  final int index;
  DeleteWatchlist(this.index);
}

class RearrangeWatchlists extends WatchlistEvent {
  final int oldIndex;
  final int newIndex;
  RearrangeWatchlists(this.oldIndex, this.newIndex);
}

class EnterEditMode extends WatchlistEvent {}

class ExitEditMode extends WatchlistEvent {}

class SearchStocks extends WatchlistEvent {
  final String query;
  SearchStocks(this.query);
}

class ShowWatchlistNameExistsError extends WatchlistEvent {
  final String message;
  ShowWatchlistNameExistsError(this.message);
}

class ClearWatchlistError extends WatchlistEvent {}