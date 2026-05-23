import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00C896);
  static const Color primaryDark = Color(0xFF00A07A);
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceVariant = Color(0xFF21262D);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color gain = Color(0xFF00C896);
  static const Color loss = Color(0xFFFF4B4B);
  static const Color gainLight = Color(0x2000C896);
  static const Color lossLight = Color(0x20FF4B4B);
  static const Color border = Color(0xFF30363D);
  static const Color accent = Color(0xFF58A6FF);
}

class AppTextStyles {
  static const TextStyle price = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  static const TextStyle priceSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle label = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}

class MarketType {
  static const String crypto = 'Crypto';
  static const String stocks = 'Stocks';
  static const String forex = 'Forex';
}
