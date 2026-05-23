import 'package:flutter/material.dart';
import 'market_screen.dart';
import 'watchlist_screen.dart';
import 'orders_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    MarketScreen(),
    WatchlistScreen(),
    OrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Markets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_rounded),
              label: 'Watchlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              label: 'Orders',
            ),
          ],
        ),
      ),
    );
  }
}
