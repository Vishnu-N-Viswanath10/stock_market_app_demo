import '../../domain/entities/stock.dart';

class StockModel extends Stock {
  const StockModel({
    required super.code,
    required super.name,
    required super.exchange,
    required super.ltp,
    required super.change,
    required super.changePercent,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      code: json['code'],
      name: json['name'],
      exchange: json['exchange'],
      ltp: json['ltp'],
      change: json['change'],
      changePercent: json['changePercent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'exchange': exchange,
      'ltp': ltp,
      'change': change,
      'changePercent': changePercent,
    };
  }
}
