import '../../domain/entities/stock.dart';

class StockModel extends Stock {
  StockModel({
    required String code,
    required String name,
    required String exchange,
    required double ltp,
    required double change,
    required double changePercent,
  }) : super(
          code: code,
          name: name,
          exchange: exchange,
          ltp: ltp,
          change: change,
          changePercent: changePercent,
        );

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