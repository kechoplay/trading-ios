import 'package:intl/intl.dart';

class Formatters {
  static final _usd = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  static final _compact = NumberFormat.compact();
  static final _percent = NumberFormat('#,##0.00');

  static String price(double value, {int decimals = 2}) {
    if (value >= 1000) return _usd.format(value);
    return '\$${value.toStringAsFixed(decimals < 4 ? (value < 1 ? 6 : 2) : decimals)}';
  }

  static String change(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${_percent.format(value)}%';
  }

  static String volume(double value) => _compact.format(value);

  static String date(DateTime dt) => DateFormat('MMM d, HH:mm').format(dt);

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
