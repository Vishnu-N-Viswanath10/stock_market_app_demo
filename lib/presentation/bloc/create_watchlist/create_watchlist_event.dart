import 'package:equatable/equatable.dart';

abstract class CreateWatchlistEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateWatchlistSubmitted extends CreateWatchlistEvent {
  final String name;
  final int currentCount;

  CreateWatchlistSubmitted(this.name, this.currentCount);

  @override
  List<Object?> get props => [name, currentCount];
}

class CreateWatchlistErrorCleared extends CreateWatchlistEvent {}
