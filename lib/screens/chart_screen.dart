import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/asset.dart';
import '../providers/market_provider.dart';
import '../providers/watchlist_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/price_chart.dart';
import 'order_sheet.dart';

class ChartScreen extends StatefulWidget {
  final Asset asset;
  const ChartScreen({super.key, required this.asset});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String _interval = '4H';
  bool _showCandles = true;

  final _intervals = ['1H', '4H', '1D', '1W', '1M'];

  @override
  Widget build(BuildContext context) {
    return Consumer2<MarketProvider, WatchlistProvider>(
      builder: (context, market, watchlist, _) {
        final asset = market.findBySymbol(widget.asset.symbol) ?? widget.asset;
        final candles = market.getCandlesFor(asset.symbol);
        final isWatching = watchlist.isWatching(asset.symbol);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(asset.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(asset.name, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isWatching ? Icons.star_rounded : Icons.star_border_rounded,
                  color: isWatching ? Colors.amber : AppColors.textSecondary,
                ),
                onPressed: () => watchlist.toggle(asset.symbol),
              ),
            ],
          ),
          body: Column(
            children: [
              // Price header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.price(asset.price),
                      style: AppTextStyles.price.copyWith(
                        color: asset.isGain ? AppColors.gain : AppColors.loss,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: asset.isGain ? AppColors.gainLight : AppColors.lossLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        Formatters.change(asset.change),
                        style: TextStyle(
                          color: asset.isGain ? AppColors.gain : AppColors.loss,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Chart type toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _ChipButton(
                      label: 'Candle',
                      selected: _showCandles,
                      onTap: () => setState(() => _showCandles = true),
                    ),
                    const SizedBox(width: 8),
                    _ChipButton(
                      label: 'Line',
                      selected: !_showCandles,
                      onTap: () => setState(() => _showCandles = false),
                    ),
                    const Spacer(),
                    ..._intervals.map((i) => _ChipButton(
                          label: i,
                          selected: _interval == i,
                          onTap: () => setState(() => _interval = i),
                        )),
                  ],
                ),
              ),
              // Chart
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: PriceChart(
                    candles: candles,
                    showCandles: _showCandles,
                    asset: asset,
                  ),
                ),
              ),
              // Stats row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Stat(label: 'Volume', value: Formatters.volume(asset.volume)),
                    _Stat(label: 'High', value: Formatters.price(asset.price * 1.03)),
                    _Stat(label: 'Low', value: Formatters.price(asset.price * 0.97)),
                    if (asset.marketCap > 0)
                      _Stat(label: 'Mkt Cap', value: Formatters.volume(asset.marketCap)),
                  ],
                ),
              ),
              // Trade buttons
              Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _openOrder(context, asset, isBuy: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gain,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Buy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _openOrder(context, asset, isBuy: false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.loss,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Sell', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openOrder(BuildContext context, Asset asset, {required bool isBuy}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => OrderSheet(asset: asset, isBuy: isBuy),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ChipButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
      ],
    );
  }
}
