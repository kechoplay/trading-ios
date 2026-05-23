import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/asset.dart';
import '../models/candle.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class PriceChart extends StatelessWidget {
  final List<CandleData> candles;
  final bool showCandles;
  final Asset asset;

  const PriceChart({
    super.key,
    required this.candles,
    required this.showCandles,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    return showCandles ? _CandleChart(candles: candles, asset: asset) : _LineChart(candles: candles, asset: asset);
  }
}

class _LineChart extends StatelessWidget {
  final List<CandleData> candles;
  final Asset asset;
  const _LineChart({required this.candles, required this.asset});

  @override
  Widget build(BuildContext context) {
    final spots = candles.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.close)).toList();
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    return LineChart(
      LineChartData(
        backgroundColor: AppColors.background,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.border, strokeWidth: 0.5),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 70,
              getTitlesWidget: (v, _) => Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(Formatters.price(v), style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minY: minY - padding,
        maxY: maxY + padding,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: asset.isGain ? AppColors.gain : AppColors.loss,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (asset.isGain ? AppColors.gain : AppColors.loss).withOpacity(0.3),
                  (asset.isGain ? AppColors.gain : AppColors.loss).withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((s) => LineTooltipItem(
              Formatters.price(s.y),
              const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            )).toList(),
          ),
        ),
      ),
    );
  }
}

class _CandleChart extends StatelessWidget {
  final List<CandleData> candles;
  final Asset asset;
  const _CandleChart({required this.candles, required this.asset});

  @override
  Widget build(BuildContext context) {
    // Display last 30 candles for readability
    final display = candles.length > 30 ? candles.sublist(candles.length - 30) : candles;

    return CustomPaint(
      painter: _CandlePainter(candles: display),
      child: Container(),
    );
  }
}

class _CandlePainter extends CustomPainter {
  final List<CandleData> candles;
  _CandlePainter({required this.candles});

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final allPrices = candles.expand((c) => [c.high, c.low]).toList();
    final minPrice = allPrices.reduce((a, b) => a < b ? a : b);
    final maxPrice = allPrices.reduce((a, b) => a > b ? a : b);
    final priceRange = maxPrice - minPrice;
    if (priceRange == 0) return;

    final candleWidth = size.width / candles.length;
    final bodyWidth = candleWidth * 0.6;
    final padding = size.height * 0.05;

    double toY(double price) => size.height - padding - ((price - minPrice) / priceRange) * (size.height - padding * 2);

    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = i * candleWidth + candleWidth / 2;
      final color = c.isBullish ? AppColors.gain : AppColors.loss;

      final wickPaint = Paint()..color = color..strokeWidth = 1;
      canvas.drawLine(Offset(x, toY(c.high)), Offset(x, toY(c.low)), wickPaint);

      final bodyTop = toY(c.isBullish ? c.close : c.open);
      final bodyBottom = toY(c.isBullish ? c.open : c.close);
      final bodyHeight = (bodyBottom - bodyTop).abs().clamp(1.0, double.infinity);

      final bodyPaint = Paint()..color = color;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - bodyWidth / 2, bodyTop, bodyWidth, bodyHeight),
          const Radius.circular(1),
        ),
        bodyPaint,
      );
    }

    // Price axis labels
    final labelPaint = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= 4; i++) {
      final price = minPrice + (priceRange * i / 4);
      final y = toY(price);
      labelPaint.text = TextSpan(
        text: '\$${price.toStringAsFixed(price < 10 ? 4 : 0)}',
        style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
      );
      labelPaint.layout();
      labelPaint.paint(canvas, Offset(size.width - labelPaint.width - 2, y - labelPaint.height / 2));

      final gridPaint = Paint()..color = AppColors.border..strokeWidth = 0.5;
      canvas.drawLine(Offset(0, y), Offset(size.width - labelPaint.width - 4, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CandlePainter old) => old.candles != candles;
}
