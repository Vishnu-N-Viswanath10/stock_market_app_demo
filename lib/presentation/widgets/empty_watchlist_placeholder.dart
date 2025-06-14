import 'package:flutter/material.dart';
import 'package:stock_market_app_demo/core/utils/app_strings.dart';

class EmptyWatchlistPlaceholder extends StatelessWidget {
  const EmptyWatchlistPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_box_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            AppStrings.noStocksInWatchlist,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.tapToAddStocks,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
