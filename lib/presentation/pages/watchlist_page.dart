import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_strings.dart';
import '../bloc/watchlist/watchlist_bloc.dart';
import '../bloc/watchlist/watchlist_event.dart';
import '../bloc/watchlist/watchlist_state.dart';
import '../widgets/watchlist_group_tabs.dart';
import '../widgets/stock_tile.dart';
import '../widgets/empty_watchlist_placeholder.dart';
import 'edit_watchlist_page.dart';
import 'search_page.dart';
import '../widgets/create_watchlist_bottom_sheet.dart';
import '../widgets/watchlist_menu_sheet.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        final stocks = state.watchlists[state.selectedGroupIndex];
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.watchlist),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            elevation: 0,
          ),
          body: Column(
            children: [
              // Watchlist group tabs and hamburger
              Row(
                children: [
                  Expanded(child: WatchlistGroupTabs()),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _showWatchlistMenu(
                      context,
                      state.groupNames.length,
                      () {
                        // onEdit callback
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditWatchlistPage(),
                          ),
                        );
                      },
                      () {
                        // onCreate callback
                        context.read<WatchlistBloc>().add(
                          WatchlistNameChanged(''),
                        );
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => CreateWatchlistBottomSheet(
                            currentWatchlistCount: state.groupNames.length,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SearchPage()),
                    );
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Text(
                          AppStrings.createNewWatchlist,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Watchlist stocks
              Expanded(
                child: stocks.isEmpty
                    ? EmptyWatchlistPlaceholder()
                    : ListView.separated(
                        itemCount: stocks.length,
                        itemBuilder: (context, index) {
                          final stock = stocks[index];
                          return GestureDetector(
                            onLongPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditWatchlistPage(),
                                ),
                              );
                            },
                            child: StockTile(stock: stock),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black12,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${stocks.length} / 20 Stocks',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWatchlistMenu(
    BuildContext context,
    int watchlistCount,
    VoidCallback onEdit,
    VoidCallback onCreate,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return WatchlistMenuSheet(
          watchlistCount: watchlistCount,
          onEdit: onEdit,
          onCreate: onCreate,
        );
      },
    );
  }
}
