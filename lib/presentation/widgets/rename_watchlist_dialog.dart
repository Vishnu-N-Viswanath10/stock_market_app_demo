import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_app_demo/core/utils/app_strings.dart';
import '../bloc/watchlist/watchlist_bloc.dart';
import '../bloc/watchlist/watchlist_event.dart';
import '../bloc/watchlist/watchlist_state.dart';

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
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
    _focusNode = FocusNode();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
    // Initialize Bloc state with current name
    context.read<WatchlistBloc>().add(WatchlistNameChanged(widget.currentName));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleRename(BuildContext context, WatchlistState state) {
    final name = state.watchlistName.trim();
    if (name.isEmpty) {
      context.read<WatchlistBloc>().add(
        ShowWatchlistNameExistsError(AppStrings.watchlistNameEmptyAlert),
      );
      return;
    }
    context.read<WatchlistBloc>().add(RenameWatchlist(widget.index, name));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WatchlistBloc, WatchlistState>(
      listenWhen: (prev, curr) =>
          prev.groupNames[widget.index] != curr.groupNames[widget.index],
      listener: (context, state) {
        // Close the dialog if the name was actually changed
        if (state.groupNames[widget.index] == state.watchlistName.trim()) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          final errorText = state.errorMessage;
          final name = state.watchlistName;
          // Keep the controller in sync with the bloc state
          if (_controller.text != name) {
            _controller.value = TextEditingValue(
              text: name,
              selection: TextSelection.collapsed(offset: name.length),
            );
          }
          return AlertDialog(
            title: Text(AppStrings.renameWatchlist),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLength: 20,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  decoration: InputDecoration(
                    labelText: AppStrings.newName,
                    counterText: '',
                  ),
                  autofocus: true,
                  onChanged: (val) {
                    context.read<WatchlistBloc>().add(
                      WatchlistNameChanged(val),
                    );
                    if (state.errorMessage != null) {
                      context.read<WatchlistBloc>().add(ClearWatchlistError());
                    }
                  },
                  onSubmitted: (_) => _handleRename(context, state),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${name.length}/20',
                    style: TextStyle(
                      color: name.length > 20 ? Colors.red : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(errorText, style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppStrings.cancel),
              ),
              TextButton(
                onPressed: () => _handleRename(context, state),
                child: Text(AppStrings.rename),
              ),
            ],
          );
        },
      ),
    );
  }
}
