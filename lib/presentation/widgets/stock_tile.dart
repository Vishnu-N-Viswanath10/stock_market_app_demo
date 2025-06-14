import 'package:flutter/material.dart';
import '../../domain/entities/stock.dart';

class StockTile extends StatelessWidget {
  final Stock stock;

  const StockTile({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final isUp = stock.change >= 0;
    return ListTile(
      title: Text(stock.code, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${stock.name} • ${stock.exchange}'),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            stock.ltp.toStringAsFixed(2),
            style: TextStyle(
              color: isUp ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${stock.change >= 0 ? '+' : ''}${stock.change.toStringAsFixed(2)} (${stock.changePercent >= 0 ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%)',
            style: TextStyle(
              color: isUp ? Colors.green : Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}