import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_strings.dart';
import '../bloc/watchlist/watchlist_bloc.dart';
import '../bloc/watchlist/watchlist_event.dart';
import '../bloc/watchlist/watchlist_state.dart';

class CreateWatchlistBottomSheet extends StatefulWidget {
  final int currentWatchlistCount;

  const CreateWatchlistBottomSheet({
    super.key,
    required this.currentWatchlistCount,
  });

  @override
  State<CreateWatchlistBottomSheet> createState() =>
      _CreateWatchlistBottomSheetState();
}

class _CreateWatchlistBottomSheetState
    extends State<CreateWatchlistBottomSheet> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    // Show keyboard automatically when the bottom sheet opens
    Future.delayed(const Duration(milliseconds: 200), () {
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

  void _handleCreate(BuildContext context, WatchlistState state) {
    final name = state.watchlistName.trim();
    if (name.isEmpty) {
      context.read<WatchlistBloc>().add(
        ShowWatchlistNameExistsError(AppStrings.watchlistNameEmptyAlert),
      );
      return;
    }
    context.read<WatchlistBloc>().add(CreateNewWatchlistGroup(name));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WatchlistBloc, WatchlistState>(
      listenWhen: (prev, curr) =>
          prev.groupNames.length != curr.groupNames.length,
      listener: (context, state) {
        // Close the sheet if a new watchlist was added
        if (state.groupNames.length > widget.currentWatchlistCount) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          final isMax = widget.currentWatchlistCount >= 5;
          final errorText = state.errorMessage;
          final name = state.watchlistName;

          // Keep the controller in sync with the bloc state
          if (_controller.text != name) {
            _controller.value = TextEditingValue(
              text: name,
              selection: TextSelection.collapsed(offset: name.length),
            );
          }

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
                const Text(
                  AppStrings.createNewWatchlist,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLength: 20,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  decoration: InputDecoration(
                    labelText: AppStrings.watchlistName,
                    counterText: '', // Hide default counter
                  ),
                  enabled: !isMax,
                  autofocus: true,
                  onChanged: (val) {
                    context.read<WatchlistBloc>().add(
                      WatchlistNameChanged(val),
                    );
                    if (state.errorMessage != null) {
                      context.read<WatchlistBloc>().add(ClearWatchlistError());
                    }
                  },
                  onSubmitted: (_) {
                    if (!isMax) _handleCreate(context, state);
                  },
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
                const SizedBox(height: 8),
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
                        : () => _handleCreate(context, state),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMax
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      AppStrings.create,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(errorText, style: TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
