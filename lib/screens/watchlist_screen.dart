import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';
import '../providers/watchlist_provider.dart';
import '../utils/constants.dart';
import '../widgets/asset_tile.dart';
import 'chart_screen.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Consumer2<WatchlistProvider, MarketProvider>(
        builder: (context, watchlist, market, _) {
          final symbols = watchlist.watchlist.toList();
          final assets = symbols
              .map((s) => market.findBySymbol(s))
              .whereType<dynamic>()
              .toList();

          if (assets.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_border_rounded, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text('No assets in watchlist', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Tap the star on any asset to add it', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black),
                    child: const Text('Browse Markets'),
                  ),
                ],
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: assets.length,
            onReorder: (_, __) {},
            itemBuilder: (context, i) {
              final asset = assets[i];
              return Dismissible(
                key: ValueKey(asset.symbol),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: AppColors.loss,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) => watchlist.remove(asset.symbol),
                child: AssetTile(
                  asset: asset,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChartScreen(asset: asset)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
