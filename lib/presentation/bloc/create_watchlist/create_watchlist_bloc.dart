import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_strings.dart';
import 'create_watchlist_event.dart';
import 'create_watchlist_state.dart';

class CreateWatchlistBloc extends Bloc<CreateWatchlistEvent, CreateWatchlistState> {
  CreateWatchlistBloc() : super(CreateWatchlistInitial()) {
    on<CreateWatchlistSubmitted>((event, emit) {
  if (event.currentCount >= 5) {
    emit(CreateWatchlistFailure(AppStrings.maxWatchlists));
  } else if (event.name.trim().isEmpty) {
    emit(CreateWatchlistFailure(AppStrings.watchlistNameEmptyAlert));
  } else {
    emit(CreateWatchlistSuccess());
  }
});

    on<CreateWatchlistErrorCleared>((event, emit) {
      emit(CreateWatchlistInitial());
    });
  }
}