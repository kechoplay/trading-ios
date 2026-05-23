import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class AssetTile extends StatelessWidget {
  final Asset asset;
  final VoidCallback onTap;

  const AssetTile({super.key, required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Color(asset.iconColor).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  asset.symbol.length > 3 ? asset.symbol.substring(0, 2) : asset.symbol.substring(0, asset.symbol.length > 2 ? 2 : 1),
                  style: TextStyle(
                    color: Color(asset.iconColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.symbol, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(asset.name, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            // Sparkline placeholder
            _MiniChart(isGain: asset.isGain),
            const SizedBox(width: 12),
            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.price(asset.price),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: asset.isGain ? AppColors.gainLight : AppColors.lossLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    Formatters.change(asset.change),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: asset.isGain ? AppColors.gain : AppColors.loss,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChart extends StatelessWidget {
  final bool isGain;
  const _MiniChart({required this.isGain});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(60, 32),
      painter: _SparklinePainter(isGain: isGain),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final bool isGain;
  _SparklinePainter({required this.isGain});

  static final _gainPoints = [0.5, 0.4, 0.6, 0.45, 0.55, 0.4, 0.3, 0.35, 0.2, 0.15];
  static final _lossPoints = [0.3, 0.35, 0.25, 0.45, 0.4, 0.55, 0.6, 0.5, 0.65, 0.75];

  @override
  void paint(Canvas canvas, Size size) {
    final pts = isGain ? _gainPoints : _lossPoints;
    final color = isGain ? AppColors.gain : AppColors.loss;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    for (int i = 0; i < pts.length; i++) {
      final x = i / (pts.length - 1) * size.width;
      final y = pts[i] * size.height;
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
