import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, 
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Watchlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: 'Portfolio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: 'Movers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          label: 'Products',
        ),
      ],
    );
  }
}