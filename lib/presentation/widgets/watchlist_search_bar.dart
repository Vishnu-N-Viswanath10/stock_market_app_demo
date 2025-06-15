import 'package:flutter/material.dart';
import '../../core/utils/app_strings.dart';
import '../pages/search_page.dart';

class WatchlistSearchBar extends StatelessWidget {
  const WatchlistSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchPage()),
          );
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              SizedBox(width: 8),
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                AppStrings.searchAndAddScrips,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
