import 'dart:math';
import '../models/asset.dart';
import '../models/candle.dart';
import '../models/order.dart';

class MockData {
  static final _rng = Random();

  static List<Asset> get assets => [
        // Crypto
        Asset(symbol: 'BTC', name: 'Bitcoin', price: 67432.50, change: 2.34, volume: 28_500_000_000, marketCap: 1_320_000_000_000, market: 'Crypto', iconColor: 0xFFF7931A),
        Asset(symbol: 'ETH', name: 'Ethereum', price: 3512.80, change: -1.12, volume: 14_200_000_000, marketCap: 421_000_000_000, market: 'Crypto', iconColor: 0xFF627EEA),
        Asset(symbol: 'SOL', name: 'Solana', price: 178.40, change: 5.67, volume: 4_800_000_000, marketCap: 78_000_000_000, market: 'Crypto', iconColor: 0xFF9945FF),
        Asset(symbol: 'BNB', name: 'BNB', price: 598.20, change: 0.89, volume: 2_100_000_000, marketCap: 87_000_000_000, market: 'Crypto', iconColor: 0xFFF3BA2F),
        Asset(symbol: 'ADA', name: 'Cardano', price: 0.5842, change: -2.45, volume: 890_000_000, marketCap: 20_500_000_000, market: 'Crypto', iconColor: 0xFF0033AD),
        Asset(symbol: 'DOGE', name: 'Dogecoin', price: 0.1732, change: 3.21, volume: 1_200_000_000, marketCap: 24_800_000_000, market: 'Crypto', iconColor: 0xFFC2A633),
        // Stocks
        Asset(symbol: 'AAPL', name: 'Apple Inc.', price: 189.30, change: 0.45, volume: 58_000_000, marketCap: 2_950_000_000_000, market: 'Stocks', iconColor: 0xFF999999),
        Asset(symbol: 'MSFT', name: 'Microsoft', price: 420.55, change: 1.23, volume: 22_000_000, marketCap: 3_120_000_000_000, market: 'Stocks', iconColor: 0xFF00A4EF),
        Asset(symbol: 'NVDA', name: 'NVIDIA', price: 875.40, change: 4.12, volume: 41_000_000, marketCap: 2_150_000_000_000, market: 'Stocks', iconColor: 0xFF76B900),
        Asset(symbol: 'TSLA', name: 'Tesla', price: 175.20, change: -2.87, volume: 95_000_000, marketCap: 558_000_000_000, market: 'Stocks', iconColor: 0xFFCC0000),
        Asset(symbol: 'META', name: 'Meta', price: 512.80, change: 1.56, volume: 18_000_000, marketCap: 1_308_000_000_000, market: 'Stocks', iconColor: 0xFF0080FB),
        Asset(symbol: 'AMZN', name: 'Amazon', price: 187.40, change: 0.78, volume: 32_000_000, marketCap: 1_960_000_000_000, market: 'Stocks', iconColor: 0xFFFF9900),
        // Forex
        Asset(symbol: 'EUR/USD', name: 'Euro / US Dollar', price: 1.0842, change: 0.12, volume: 5_800_000_000, marketCap: 0, market: 'Forex', iconColor: 0xFF003399),
        Asset(symbol: 'GBP/USD', name: 'British Pound / USD', price: 1.2654, change: -0.08, volume: 3_200_000_000, marketCap: 0, market: 'Forex', iconColor: 0xFF012169),
        Asset(symbol: 'USD/JPY', name: 'US Dollar / Yen', price: 156.42, change: 0.34, volume: 4_100_000_000, marketCap: 0, market: 'Forex', iconColor: 0xFFBC002D),
        Asset(symbol: 'USD/CHF', name: 'US Dollar / Swiss Franc', price: 0.9021, change: -0.15, volume: 1_800_000_000, marketCap: 0, market: 'Forex', iconColor: 0xFFFF0000),
      ];

  static List<CandleData> generateCandles(double basePrice, int count) {
    final candles = <CandleData>[];
    double price = basePrice;
    final now = DateTime.now();

    for (int i = count; i >= 0; i--) {
      final volatility = basePrice * 0.02;
      final open = price;
      final change = (_rng.nextDouble() - 0.48) * volatility;
      final close = open + change;
      final high = max(open, close) + _rng.nextDouble() * volatility * 0.5;
      final low = min(open, close) - _rng.nextDouble() * volatility * 0.5;
      final volume = basePrice * 100 * (_rng.nextDouble() * 2 + 0.5);

      candles.add(CandleData(
        time: now.subtract(Duration(hours: i * 4)),
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume,
      ));
      price = close;
    }
    return candles;
  }

  static List<Order> get sampleOrders => [
        Order(id: '1', symbol: 'BTC', side: OrderSide.buy, type: OrderType.market, quantity: 0.05, price: 67000, status: OrderStatus.filled, createdAt: DateTime.now().subtract(const Duration(hours: 2))),
        Order(id: '2', symbol: 'ETH', side: OrderSide.sell, type: OrderType.limit, quantity: 1.5, price: 3600, status: OrderStatus.open, createdAt: DateTime.now().subtract(const Duration(hours: 5))),
        Order(id: '3', symbol: 'AAPL', side: OrderSide.buy, type: OrderType.market, quantity: 10, price: 189, status: OrderStatus.filled, createdAt: DateTime.now().subtract(const Duration(days: 1))),
      ];
}
