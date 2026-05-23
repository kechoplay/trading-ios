import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class MarketSummaryCard extends StatelessWidget {
  final String market;
  final List<Asset> assets;

  const MarketSummaryCard({super.key, required this.market, required this.assets});

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) return const SizedBox.shrink();

    final gainers = assets.where((a) => a.isGain).length;
    final losers = assets.length - gainers;
    final avgChange = assets.map((a) => a.change).reduce((a, b) => a + b) / assets.length;
    final totalVol = assets.map((a) => a.volume).reduce((a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: avgChange >= 0
              ? [AppColors.gainLight, AppColors.surface]
              : [AppColors.lossLight, AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                market,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: avgChange >= 0 ? AppColors.gainLight : AppColors.lossLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Avg ${Formatters.change(avgChange)}',
                  style: TextStyle(
                    color: avgChange >= 0 ? AppColors.gain : AppColors.loss,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Metric(label: 'Gainers', value: '$gainers', color: AppColors.gain),
              const SizedBox(width: 24),
              _Metric(label: 'Losers', value: '$losers', color: AppColors.loss),
              const SizedBox(width: 24),
              _Metric(label: 'Volume 24H', value: Formatters.volume(totalVol), color: AppColors.accent),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Metric({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
      ],
    );
  }
}
