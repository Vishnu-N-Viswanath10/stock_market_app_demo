import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_app_demo/core/utils/app_strings.dart';
import '../bloc/watchlist/watchlist_bloc.dart';
import '../bloc/watchlist/watchlist_event.dart';
import '../bloc/watchlist/watchlist_state.dart';

class EditWatchlistPage extends StatelessWidget {
  const EditWatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        final stocks = state.watchlists[state.selectedGroupIndex];
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.editWatchlist),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex -= 1;
              context.read<WatchlistBloc>().add(
                RearrangeStocksInWatchlist(
                  state.selectedGroupIndex,
                  oldIndex,
                  newIndex,
                ),
              );
            },
            children: [
              for (int i = 0; i < stocks.length; i++)
                Column(
                  key: ValueKey(stocks[i].code),
                  children: [
                    Dismissible(
                      key: ValueKey('dismiss_${stocks[i].code}'),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        context.read<WatchlistBloc>().add(
                          RemoveStockFromWatchlist(
                            state.selectedGroupIndex,
                            stocks[i],
                          ),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(stocks[i].code),
                        subtitle: Text(
                          '${stocks[i].name} • ${stocks[i].exchange}',
                        ),
                        trailing: const Icon(Icons.drag_handle),
                      ),
                    ),
                    if (i < stocks.length - 1)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.black12,
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
