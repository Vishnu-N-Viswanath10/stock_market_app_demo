import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_app_demo/core/utils/app_strings.dart';
import '../../core/utils/constants.dart';
import '../../domain/entities/stock.dart';
import '../bloc/watchlist/watchlist_bloc.dart';
import '../bloc/watchlist/watchlist_event.dart';
import '../bloc/watchlist/watchlist_state.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final watchlistBloc = context.read<WatchlistBloc>();
    final stockRepository = watchlistBloc.stockRepository;

    return FutureBuilder<List<Stock>>(
      future: stockRepository.getAllStocks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final allStocks = snapshot.data!;
        final defaultStocks = allStocks.take(3).toList();

        return BlocProvider(
          create: (_) => SearchBloc(
            stockRepository: stockRepository,
            defaultStocks: defaultStocks,
          )..add(SearchQueryChanged('')),
          child: BlocBuilder<WatchlistBloc, WatchlistState>(
            builder: (context, watchlistState) {
              final currentWatchlist =
                  watchlistState.watchlists[watchlistState.selectedGroupIndex];

              return BlocBuilder<SearchBloc, SearchState>(
                builder: (context, searchState) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      title: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: AppStrings.searchHint,
                          border: InputBorder.none,
                        ),
                        onChanged: (val) {
                          context.read<SearchBloc>().add(
                            SearchQueryChanged(val),
                          );
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    body: ListView.builder(
                      itemCount: searchState.results.length,
                      itemBuilder: (context, index) {
                        final stock = searchState.results[index];
                        final inWatchlist = currentWatchlist.any(
                          (s) => s.code == stock.code,
                        );

                        return ListTile(
                          title: Text(stock.code),
                          subtitle: Text('${stock.name} • ${stock.exchange}'),
                          trailing: IconButton(
                            icon: Icon(
                              inWatchlist
                                  ? Icons.check_circle
                                  : Icons.add_circle_outline,
                              color: inWatchlist ? Colors.green : Colors.grey,
                            ),
                            onPressed: () {
                              if (inWatchlist) {
                                watchlistBloc.add(
                                  RemoveStockFromWatchlist(
                                    watchlistState.selectedGroupIndex,
                                    stock,
                                  ),
                                );
                              } else {
                                if (currentWatchlist.length >=
                                    kMaxStocksPerWatchlist) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                        AppStrings.watchlistFull,
                                      ),
                                      content: const Text(
                                        AppStrings.watchlistFullAlert,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(AppStrings.ok),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  watchlistBloc.add(
                                    AddStockToWatchlist(
                                      watchlistState.selectedGroupIndex,
                                      stock,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
