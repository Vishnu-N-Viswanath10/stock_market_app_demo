import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_app_demo/core/utils/app_strings.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';

class EditWatchlistPage extends StatelessWidget {
  const EditWatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        final stocks = state.watchlists[state.selectedGroupIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.editWatchlist),
            actions: [
              IconButton(
                icon: Icon(Icons.check, color: Colors.green),
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
                Dismissible(
                  key: ValueKey(stocks[i].code),
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    key: ValueKey(stocks[i].code),
                    title: Text(stocks[i].code),
                    subtitle: Text('${stocks[i].name} • ${stocks[i].exchange}'),
                    trailing: Icon(Icons.drag_handle),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}