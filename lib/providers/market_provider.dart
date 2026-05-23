import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../models/candle.dart';
import '../utils/mock_data.dart';

class MarketProvider extends ChangeNotifier {
  List<Asset> _assets = [];
  String _selectedMarket = 'Crypto';
  bool _isLoading = true;
  Timer? _priceTimer;
  final _rng = Random();

  List<Asset> get assets => _assets;
  String get selectedMarket => _selectedMarket;
  bool get isLoading => _isLoading;

  List<Asset> get filteredAssets =>
      _assets.where((a) => a.market == _selectedMarket).toList();

  List<Asset> get topGainers {
    final sorted = [..._assets]..sort((a, b) => b.change.compareTo(a.change));
    return sorted.take(5).toList();
  }

  List<Asset> get topLosers {
    final sorted = [..._assets]..sort((a, b) => a.change.compareTo(b.change));
    return sorted.take(5).toList();
  }

  MarketProvider() {
    _init();
  }

  void _init() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _assets = MockData.assets;
    _isLoading = false;
    notifyListeners();
    _startPriceFeed();
  }

  void _startPriceFeed() {
    _priceTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _assets = _assets.map((a) {
        final delta = (_rng.nextDouble() - 0.49) * a.price * 0.003;
        final newPrice = max(0.0001, a.price + delta);
        final newChange = a.change + (_rng.nextDouble() - 0.5) * 0.1;
        return a.copyWith(price: newPrice, change: newChange.clamp(-30.0, 30.0));
      }).toList();
      notifyListeners();
    });
  }

  void selectMarket(String market) {
    _selectedMarket = market;
    notifyListeners();
  }

  Asset? findBySymbol(String symbol) {
    try {
      return _assets.firstWhere((a) => a.symbol == symbol);
    } catch (_) {
      return null;
    }
  }

  List<CandleData> getCandlesFor(String symbol) {
    final asset = findBySymbol(symbol);
    if (asset == null) return [];
    return MockData.generateCandles(asset.price, 90);
  }

  @override
  void dispose() {
    _priceTimer?.cancel();
    super.dispose();
  }
}
