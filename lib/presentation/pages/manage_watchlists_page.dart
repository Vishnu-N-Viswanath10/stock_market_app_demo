import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_app_demo/core/utils/app_strings.dart';
import '../bloc/watchlist/watchlist_bloc.dart';
import '../bloc/watchlist/watchlist_event.dart';
import '../bloc/watchlist/watchlist_state.dart';
import '../widgets/rename_watchlist_dialog.dart';

class ManageWatchlistsPage extends StatelessWidget {
  const ManageWatchlistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(AppStrings.manageWatchlists)),
          body: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex -= 1;
              context.read<WatchlistBloc>().add(
                RearrangeWatchlists(oldIndex, newIndex),
              );
            },
            children: [
              for (int i = 0; i < state.groupNames.length; i++)
                Dismissible(
                  key: ValueKey(state.groupNames[i]),
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
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to delete "$name"?',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppStrings.cancel),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        context.read<WatchlistBloc>().add(
                          DeleteWatchlist(index),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(AppStrings.delete),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
