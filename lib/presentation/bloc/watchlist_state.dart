import '../../domain/entities/stock.dart';

class WatchlistState {
  final List<String> groupNames;
  final List<List<Stock>> watchlists;
  final int selectedGroupIndex;
  final bool isEditMode;
  final List<Stock> searchResults;
  final String? errorMessage;

  WatchlistState({
    required this.groupNames,
    required this.watchlists,
    required this.selectedGroupIndex,
    required this.isEditMode,
    required this.searchResults,
    this.errorMessage,
  });

  factory WatchlistState.initial() => WatchlistState(
        groupNames: ['NIFTY'],
        watchlists: [[]],
        selectedGroupIndex: 0,
        isEditMode: false,
        searchResults: [],
        errorMessage: null,
      );

  WatchlistState copyWith({
    List<String>? groupNames,
    List<List<Stock>>? watchlists,
    int? selectedGroupIndex,
    bool? isEditMode,
    List<Stock>? searchResults,
    String? errorMessage,
  }) {
    return WatchlistState(
      groupNames: groupNames ?? this.groupNames,
      watchlists: watchlists ?? this.watchlists,
      selectedGroupIndex: selectedGroupIndex ?? this.selectedGroupIndex,
      isEditMode: isEditMode ?? this.isEditMode,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: errorMessage,
    );
  }
}