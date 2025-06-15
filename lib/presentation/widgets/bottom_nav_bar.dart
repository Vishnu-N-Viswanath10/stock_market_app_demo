import 'package:flutter/material.dart';

import '../../core/utils/app_strings.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: AppStrings.watchlist,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: AppStrings.orders,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: AppStrings.portfolio,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: AppStrings.movers,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          label: AppStrings.products,
        ),
      ],
    );
  }
}
