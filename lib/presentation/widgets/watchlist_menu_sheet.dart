import 'package:flutter/material.dart';
import 'package:stock_market_app_demo/core/utils/app_strings.dart';
import '../pages/manage_watchlists_page.dart';

class WatchlistMenuSheet extends StatelessWidget {
  final int watchlistCount;
  final VoidCallback onEdit;
  final VoidCallback onCreate;

  const WatchlistMenuSheet({
    super.key,
    required this.watchlistCount,
    required this.onEdit,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final isMax = watchlistCount >= 5;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.create_new_folder),
              title: Text(AppStrings.createNewWatchlist),
              trailing: Text(
                '$watchlistCount/5',
                style: TextStyle(
                  color: isMax ? Colors.red : Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              enabled: !isMax,
              onTap: !isMax
                  ? () {
                      Navigator.pop(context);
                      onCreate();
                    }
                  : null,
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(AppStrings.editCurrentWatchlist),
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(AppStrings.manageWatchlists),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ManageWatchlistsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
