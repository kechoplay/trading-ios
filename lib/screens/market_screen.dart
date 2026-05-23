import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';
import '../utils/constants.dart';
import '../widgets/asset_tile.dart';
import '../widgets/market_summary_card.dart';
import 'chart_screen.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TradePro',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => _showSearch(context),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Crypto'),
              Tab(text: 'Stocks'),
              Tab(text: 'Forex'),
            ],
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: TabBarView(
          children: [
            _MarketList(market: 'Crypto'),
            _MarketList(market: 'Stocks'),
            _MarketList(market: 'Forex'),
          ],
        ),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(context: context, delegate: _AssetSearchDelegate());
  }
}

class _MarketList extends StatelessWidget {
  final String market;
  const _MarketList({required this.market});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        final assets = provider.assets.where((a) => a.market == market).toList();
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MarketSummaryCard(market: market, assets: assets),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => AssetTile(
                    asset: assets[index],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChartScreen(asset: assets[index]),
                      ),
                    ),
                  ),
                  childCount: assets.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ),
        );
      },
    );
  }
}

class _AssetSearchDelegate extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context).copyWith(
        scaffoldBackgroundColor: AppColors.background,
        inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
      );

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final provider = context.read<MarketProvider>();
    final results = query.isEmpty
        ? provider.assets
        : provider.assets
            .where((a) =>
                a.symbol.toLowerCase().contains(query.toLowerCase()) ||
                a.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) => AssetTile(
        asset: results[i],
        onTap: () {
          close(context, results[i].symbol);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChartScreen(asset: results[i])),
          );
        },
      ),
    );
  }
}
