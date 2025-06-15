import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_app_demo/core/utils/app_strings.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_event.dart';
import '../bloc/navigation/navigation_state.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/tab_placeholder.dart';
import 'watchlist_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<Widget> _pages = [
    WatchlistPage(),
    const TabPlaceholder(
      title: AppStrings.orders,
      message: AppStrings.ordersPlaceholder,
      icon: Icons.receipt_long,
    ),
    const TabPlaceholder(
      title: AppStrings.portfolio,
      message: AppStrings.portfolioPlaceholder,
      icon: Icons.pie_chart,
    ),
    const TabPlaceholder(
      title: AppStrings.movers,
      message: AppStrings.moversPlaceholder,
      icon: Icons.trending_up,
    ),
    const TabPlaceholder(
      title: AppStrings.products,
      message: AppStrings.productsPlaceholder,
      icon: Icons.widgets,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, navState) {
        return Scaffold(
          body: _pages[navState.selectedIndex],
          bottomNavigationBar: BottomNavBar(
            selectedIndex: navState.selectedIndex,
            onTap: (index) {
              context.read<NavigationBloc>().add(NavigationTabChanged(index));
            },
          ),
        );
      },
    );
  }
}
