import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_app_demo/core/utils/app_strings.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';

class RenameWatchlistDialog extends StatefulWidget {
  final int index;
  final String currentName;

  const RenameWatchlistDialog({
    super.key,
    required this.index,
    required this.currentName,
  });

  @override
  State<RenameWatchlistDialog> createState() => _RenameWatchlistDialogState();
}

class _RenameWatchlistDialogState extends State<RenameWatchlistDialog> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
    // Focus the text field automatically
    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleRename(BuildContext context) {
    context.read<WatchlistBloc>().add(
      RenameWatchlist(widget.index, _controller.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WatchlistBloc, WatchlistState>(
      listenWhen: (prev, curr) =>
          prev.groupNames[widget.index] != curr.groupNames[widget.index],
      listener: (context, state) {
        // Only close if the name was actually changed
        if (state.groupNames[widget.index] == _controller.text.trim()) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          final errorText = state.errorMessage;

          return AlertDialog(
            title: Text(AppStrings.renameWatchlist),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: AppStrings.newName,
                  ),
                  autofocus: true,
                  onChanged: (_) {
                    if (errorText != null) {
                      context.read<WatchlistBloc>().add(ClearWatchlistError());
                    }
                  },
                  onSubmitted: (_) => _handleRename(context),
                ),
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorText,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppStrings.cancel),
              ),
              TextButton(
                onPressed: () => _handleRename(context),
                child: Text(AppStrings.cancel),
              ),
            ],
          );
        },
      ),
    );
  }
}