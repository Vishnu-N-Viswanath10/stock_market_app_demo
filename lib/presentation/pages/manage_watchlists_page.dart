import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_app_demo/core/utils/app_strings.dart';
import '../bloc/watchlist/watchlist_bloc.dart';
import '../bloc/watchlist/watchlist_event.dart';
import '../bloc/watchlist/watchlist_state.dart';
import '../widgets/delete_watchlist_confirmation_sheet.dart';
import '../widgets/rename_watchlist_dialog.dart';

class ManageWatchlistsPage extends StatelessWidget {
  const ManageWatchlistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.manageWatchlists),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
          ),
          body: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex -= 1;
              context.read<WatchlistBloc>().add(
                RearrangeWatchlists(oldIndex, newIndex),
              );
            },
            children: [
              for (int i = 0; i < state.groupNames.length; i++)
                Column(
                  key: ValueKey(state.groupNames[i]),
                  children: [
                    Dismissible(
                      key: ValueKey('dismiss_${state.groupNames[i]}'),
                      direction: DismissDirection.none,
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showRenameDialog(context, i, state.groupNames[i]);
                          },
                        ),
                        title: Text(state.groupNames[i]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(
                              context,
                              i,
                              state.groupNames[i],
                            );
                          },
                        ),
                      ),
                    ),
                    if (i < state.groupNames.length - 1)
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

  void _showRenameDialog(BuildContext context, int index, String currentName) {
    showDialog(
      context: context,
      builder: (context) =>
          RenameWatchlistDialog(index: index, currentName: currentName),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index, String name) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      builder: (context) =>
          DeleteWatchlistConfirmationSheet(index: index, name: name),
    );
  }
}
