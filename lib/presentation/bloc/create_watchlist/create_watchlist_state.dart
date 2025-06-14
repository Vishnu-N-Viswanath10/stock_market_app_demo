import 'package:equatable/equatable.dart';

abstract class CreateWatchlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateWatchlistInitial extends CreateWatchlistState {}

class CreateWatchlistSuccess extends CreateWatchlistState {}

class CreateWatchlistFailure extends CreateWatchlistState {
  final String message;
  CreateWatchlistFailure(this.message);

  @override
  List<Object?> get props => [message];
}