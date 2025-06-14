import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_strings.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';

class CreateWatchlistBottomSheet extends StatefulWidget {
  final int currentWatchlistCount;

  const CreateWatchlistBottomSheet({super.key, required this.currentWatchlistCount});

  @override
  State<CreateWatchlistBottomSheet> createState() => _CreateWatchlistBottomSheetState();
}

class _CreateWatchlistBottomSheetState extends State<CreateWatchlistBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? _prevWatchlistCount;

  @override
  void initState() {
    super.initState();
    _prevWatchlistCount = widget.currentWatchlistCount;
    // Show keyboard automatically when the bottom sheet opens
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

  void _handleCreate(BuildContext context) {
    context.read<WatchlistBloc>().add(
      CreateNewWatchlistGroup(_controller.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WatchlistBloc, WatchlistState>(
      listenWhen: (prev, curr) => prev.groupNames.length != curr.groupNames.length,
      listener: (context, state) {
        // Only close the sheet if a new watchlist was actually added
        if (_prevWatchlistCount != null && state.groupNames.length > _prevWatchlistCount!) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          final isMax = widget.currentWatchlistCount >= 5;
          final errorText = state.errorMessage;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.createNewWatchlist,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: AppStrings.watchlistName,
                  ),
                  enabled: !isMax,
                  autofocus: true,
                  onChanged: (_) {
                    if (errorText != null) {
                      context.read<WatchlistBloc>().add(ClearWatchlistError());
                    }
                  },
                  onSubmitted: (_) {
                    if (!isMax) _handleCreate(context);
                  },
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isMax
                        ? () {
                            context.read<WatchlistBloc>().add(
                                  ShowWatchlistNameExistsError(
                                    AppStrings.maxWatchlists,
                                  ),
                                );
                          }
                        : () => _handleCreate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMax ? Colors.grey : Theme.of(context).primaryColor,
                    ),
                    child: Text(AppStrings.create,
                    style: TextStyle(color: Colors.white)),
                  ),
                ),
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorText,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}