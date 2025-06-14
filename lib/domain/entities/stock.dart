import 'package:equatable/equatable.dart';

class Stock extends Equatable {
  final String code;
  final String name;
  final String exchange;
  final double ltp;
  final double change;
  final double changePercent;

  const Stock({
    required this.code,
    required this.name,
    required this.exchange,
    required this.ltp,
    required this.change,
    required this.changePercent,
  });

  @override
  List<Object?> get props => [code, name, exchange, ltp, change, changePercent];
}