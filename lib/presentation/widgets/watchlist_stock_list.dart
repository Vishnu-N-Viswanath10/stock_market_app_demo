import 'package:flutter/material.dart';
import 'package:stock_market_app_demo/presentation/widgets/empty_watchlist_placeholder.dart';
import '../widgets/stock_tile.dart';

class WatchlistStockList extends StatelessWidget {
  final List stocks;
  final VoidCallback onEdit;

  const WatchlistStockList({
    super.key,
    required this.stocks,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (stocks.isEmpty) {
      return const EmptyWatchlistPlaceholder();
    }
    return ListView.separated(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return GestureDetector(
          onLongPress: onEdit,
          child: StockTile(stock: stock),
        );
      },
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 1, color: Colors.black12),
    );
  }
}
