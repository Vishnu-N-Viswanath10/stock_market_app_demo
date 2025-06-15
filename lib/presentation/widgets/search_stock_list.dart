import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_strings.dart';
import '../../core/utils/constants.dart';
import '../../domain/entities/stock.dart';
import '../bloc/watchlist/watchlist_bloc.dart';
import '../bloc/watchlist/watchlist_event.dart';

class SearchStockList extends StatelessWidget {
  final List<Stock> stocks;
  final List<Stock> currentWatchlist;
  final int selectedGroupIndex;

  const SearchStockList({
    super.key,
    required this.stocks,
    required this.currentWatchlist,
    required this.selectedGroupIndex,
  });

  @override
  Widget build(BuildContext context) {
    final watchlistBloc = context.read<WatchlistBloc>();

    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        final inWatchlist = currentWatchlist.any((s) => s.code == stock.code);

        return ListTile(
          title: Text(stock.code),
          subtitle: Text('${stock.name} • ${stock.exchange}'),
          trailing: IconButton(
            icon: Icon(
              inWatchlist ? Icons.check_circle : Icons.add_circle_outline,
              color: inWatchlist ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              if (inWatchlist) {
                watchlistBloc.add(
                  RemoveStockFromWatchlist(selectedGroupIndex, stock),
                );
              } else {
                if (currentWatchlist.length >= kMaxStocksPerWatchlist) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(AppStrings.watchlistFull),
                      content: const Text(AppStrings.watchlistFullAlert),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(AppStrings.ok),
                        ),
                      ],
                    ),
                  );
                } else {
                  watchlistBloc.add(
                    AddStockToWatchlist(selectedGroupIndex, stock),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }
}