import '../../../domain/entities/stock.dart';

class WatchlistState {
  final List<String> groupNames;
  final List<List<Stock>> watchlists;
  final int selectedGroupIndex;
  final bool isEditMode;
  final List<Stock> searchResults;
  final String? errorMessage;
  final String watchlistName;

  WatchlistState({
    required this.groupNames,
    required this.watchlists,
    required this.selectedGroupIndex,
    required this.isEditMode,
    required this.searchResults,
    this.errorMessage,
    required this.watchlistName,
  });

  factory WatchlistState.initial() => WatchlistState(
    groupNames: ['NIFTY'],
    watchlists: [[]],
    selectedGroupIndex: 0,
    isEditMode: false,
    searchResults: [],
    errorMessage: null,
    watchlistName: '',
  );

  WatchlistState copyWith({
    List<String>? groupNames,
    List<List<Stock>>? watchlists,
    int? selectedGroupIndex,
    bool? isEditMode,
    List<Stock>? searchResults,
    String? errorMessage,
    String? watchlistName,
  }) {
    return WatchlistState(
      groupNames: groupNames ?? this.groupNames,
      watchlists: watchlists ?? this.watchlists,
      selectedGroupIndex: selectedGroupIndex ?? this.selectedGroupIndex,
      isEditMode: isEditMode ?? this.isEditMode,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: errorMessage,
      watchlistName: watchlistName ?? this.watchlistName,
    );
  }
}
