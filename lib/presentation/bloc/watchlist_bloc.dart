import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_app_demo/core/utils/app_strings.dart';
import '../../core/utils/constants.dart';
import '../../data/datasources/watchlist_local_data_source.dart';
import '../../data/models/stock_model.dart';
import '../../domain/entities/stock.dart';
import '../../domain/repositories/stock_repository.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final StockRepository stockRepository;
  final WatchlistLocalDataSource localDataSource;

  WatchlistBloc({required this.stockRepository, required this.localDataSource})
    : super(WatchlistState.initial()) {
    on<LoadWatchlistsFromStorage>(_onLoadWatchlistsFromStorage);

    on<SwitchWatchlistGroup>((event, emit) {
      emit(
        state.copyWith(selectedGroupIndex: event.groupIndex, isEditMode: false),
      );
    });

    on<AddStockToWatchlist>((event, emit) async {
      final groupIndex = event.groupIndex;
      final stock = event.stock;
      final watchlists = List<List<Stock>>.from(state.watchlists);
      if (!watchlists[groupIndex].any((s) => s.code == stock.code) &&
          watchlists[groupIndex].length < kMaxStocksPerWatchlist) {
        watchlists[groupIndex] = List<Stock>.from(watchlists[groupIndex])
          ..add(stock);
        final newState = state.copyWith(
          watchlists: watchlists,
          errorMessage: null,
        );
        emit(newState);
        await _saveToStorage(newState);
      } else if (watchlists[groupIndex].length >= kMaxStocksPerWatchlist) {
        emit(state.copyWith(errorMessage: AppStrings.watchlistFull));
      }
    });

    on<RemoveStockFromWatchlist>((event, emit) async {
      final groupIndex = event.groupIndex;
      final stock = event.stock;
      final watchlists = List<List<Stock>>.from(state.watchlists);
      watchlists[groupIndex] = List<Stock>.from(watchlists[groupIndex])
        ..removeWhere((s) => s.code == stock.code);
      final newState = state.copyWith(
        watchlists: watchlists,
        errorMessage: null,
      );
      emit(newState);
      await _saveToStorage(newState);
    });

    on<RearrangeStocksInWatchlist>((event, emit) async {
      final groupIndex = event.groupIndex;
      final oldIndex = event.oldIndex;
      final newIndex = event.newIndex;
      final watchlists = List<List<Stock>>.from(state.watchlists);
      final stocks = List<Stock>.from(watchlists[groupIndex]);
      final stock = stocks.removeAt(oldIndex);
      stocks.insert(newIndex, stock);
      watchlists[groupIndex] = stocks;
      final newState = state.copyWith(
        watchlists: watchlists,
        errorMessage: null,
      );
      emit(newState);
      await _saveToStorage(newState);
    });

    on<CreateNewWatchlistGroup>((event, emit) async {
      final trimmedName = event.groupName.trim();
      final exists = state.groupNames.any(
        (name) => name.toLowerCase() == trimmedName.toLowerCase(),
      );
      if (exists) {
        emit(state.copyWith(errorMessage: AppStrings.watchlistNameExists));
        return;
      }
      if (state.groupNames.length >= kMaxWatchlists) {
        emit(state.copyWith(errorMessage: AppStrings.maxWatchlists));
        return;
      }
      final groupNames = List<String>.from(state.groupNames)..add(trimmedName);
      final watchlists = List<List<Stock>>.from(state.watchlists)
        ..add(event.initialStock != null ? [event.initialStock!] : []);
      final newState = state.copyWith(
        groupNames: groupNames,
        watchlists: watchlists,
        selectedGroupIndex: groupNames.length - 1,
        errorMessage: null,
      );
      emit(newState);
      await _saveToStorage(newState);
    });

    on<RenameWatchlist>((event, emit) async {
      final newName = event.newName.trim();
      final exists = state.groupNames.asMap().entries.any(
        (entry) =>
            entry.key != event.index &&
            entry.value.toLowerCase() == newName.toLowerCase(),
      );
      if (exists) {
        emit(state.copyWith(errorMessage: AppStrings.watchlistNameExists));
        return;
      }
      final groupNames = List<String>.from(state.groupNames);
      groupNames[event.index] = newName;
      final newState = state.copyWith(
        groupNames: groupNames,
        errorMessage: null,
      );
      emit(newState);
      await _saveToStorage(newState);
    });

    on<DeleteWatchlist>((event, emit) async {
      final groupNames = List<String>.from(state.groupNames);
      final watchlists = List<List<Stock>>.from(state.watchlists);
      groupNames.removeAt(event.index);
      watchlists.removeAt(event.index);
      int newSelected = state.selectedGroupIndex;
      if (newSelected >= groupNames.length) newSelected = groupNames.length - 1;
      final newState = state.copyWith(
        groupNames: groupNames,
        watchlists: watchlists,
        selectedGroupIndex: newSelected < 0 ? 0 : newSelected,
        errorMessage: null,
      );
      emit(newState);
      await _saveToStorage(newState);
    });

    on<RearrangeWatchlists>((event, emit) async {
      final groupNames = List<String>.from(state.groupNames);
      final watchlists = List<List<Stock>>.from(state.watchlists);

      final name = groupNames.removeAt(event.oldIndex);
      final list = watchlists.removeAt(event.oldIndex);

      groupNames.insert(event.newIndex, name);
      watchlists.insert(event.newIndex, list);

      final newState = state.copyWith(
        groupNames: groupNames,
        watchlists: watchlists,
        errorMessage: null,
      );
      emit(newState);
      await _saveToStorage(newState);
    });

    on<EnterEditMode>((event, emit) {
      emit(state.copyWith(isEditMode: true));
    });

    on<ExitEditMode>((event, emit) {
      emit(state.copyWith(isEditMode: false));
    });

    on<ShowWatchlistNameExistsError>((event, emit) {
      emit(state.copyWith(errorMessage: event.message));
    });

    on<ClearWatchlistError>((event, emit) {
      emit(state.copyWith(errorMessage: null));
    });
  }

  Future<void> _onLoadWatchlistsFromStorage(
    LoadWatchlistsFromStorage event,
    Emitter<WatchlistState> emit,
  ) async {
    final data = await localDataSource.loadWatchlists();
    if (data != null) {
      final groupNames = List<String>.from(data['groupNames']);
      final watchlists = (data['watchlists'] as List)
          .map<List<StockModel>>(
            (list) => (list as List)
                .map((s) => StockModel.fromJson(s as Map<String, dynamic>))
                .toList(),
          )
          .toList();
      emit(
        state.copyWith(
          groupNames: groupNames,
          watchlists: watchlists,
          selectedGroupIndex: 0,
          errorMessage: null,
        ),
      );
    }
  }

  Future<void> _saveToStorage(WatchlistState state) async {
    await localDataSource.saveWatchlists(
      state.groupNames,
      state.watchlists
          .map(
            (list) => list
                .map(
                  (s) => StockModel(
                    code: s.code,
                    name: s.name,
                    exchange: s.exchange,
                    ltp: s.ltp,
                    change: s.change,
                    changePercent: s.changePercent,
                  ),
                )
                .toList(),
          )
          .toList(),
    );
  }
}
