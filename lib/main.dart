import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/app_strings.dart';
import 'data/datasources/mock_stock_data_source.dart';
import 'data/datasources/watchlist_local_data_source.dart';
import 'data/repositories/stock_repository_impl.dart';
import 'domain/repositories/stock_repository.dart';
import 'presentation/bloc/watchlist_bloc.dart';
import 'presentation/bloc/watchlist_event.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/bloc/navigation/navigation_bloc.dart';

void main() {
  // Ensure Flutter bindings are initialized before using shared_preferences
  WidgetsFlutterBinding.ensureInitialized();

  // Create your repositories and data sources
  final stockRepository = StockRepositoryImpl(MockStockDataSource());
  final watchlistLocalDataSource = WatchlistLocalDataSource();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<StockRepository>.value(value: stockRepository),
        RepositoryProvider<WatchlistLocalDataSource>.value(value: watchlistLocalDataSource),
      ],
      child: BlocProvider(
        create: (context) => WatchlistBloc(
          stockRepository: stockRepository,
          localDataSource: watchlistLocalDataSource,
        )..add(LoadWatchlistsFromStorage()),
        child: BlocProvider(
        create: (_) => NavigationBloc(),
          child: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.createNewWatchlist,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}