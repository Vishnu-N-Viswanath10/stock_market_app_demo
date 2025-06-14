import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_strings.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';

class CreateWatchlistPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  CreateWatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.createNewWatchlist)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: AppStrings.watchlistName),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  context.read<WatchlistBloc>().add(
                        CreateNewWatchlistGroup(_controller.text.trim()),
                      );
                  Navigator.pop(context);
                }
              },
              child: Text(AppStrings.create),
            ),
          ],
        ),
      ),
    );
  }
}