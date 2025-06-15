import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_strings.dart';
import '../bloc/watchlist/watchlist_bloc.dart';
import '../bloc/watchlist/watchlist_event.dart';
import '../bloc/watchlist/watchlist_state.dart';
import '../widgets/empty_watchlist_placeholder.dart';
import '../widgets/stock_tile.dart';
import '../widgets/watchlist_group_tabs.dart';
import '../widgets/watchlist_list_footer.dart';
import '../widgets/watchlist_search_bar.dart';
import 'edit_watchlist_page.dart';
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
          body: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: WatchlistGroupTabs()),
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => _showWatchlistMenu(
                          context,
                          state.groupNames.length,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditWatchlistPage(),
                              ),
                            );
                          },
                          () {
                            context.read<WatchlistBloc>().add(
                              WatchlistNameChanged(''),
                            );
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Theme.of(
                                context,
                              ).secondaryHeaderColor,
                              builder: (context) => CreateWatchlistBottomSheet(
                                currentWatchlistCount: state.groupNames.length,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const WatchlistSearchBar(),
                  Expanded(
                    child: stocks.isEmpty
                        ? const EmptyWatchlistPlaceholder()
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
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: Center(child: WatchlistFooter(count: stocks.length)),
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
      backgroundColor: Theme.of(context).secondaryHeaderColor,
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
