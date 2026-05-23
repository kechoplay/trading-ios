class Asset {
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double volume;
  final double marketCap;
  final String market;
  final int iconColor;
  bool isInWatchlist;

  Asset({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.volume,
    required this.marketCap,
    required this.market,
    required this.iconColor,
    this.isInWatchlist = false,
  });

  bool get isGain => change >= 0;

  Asset copyWith({
    double? price,
    double? change,
    double? volume,
    bool? isInWatchlist,
  }) {
    return Asset(
      symbol: symbol,
      name: name,
      price: price ?? this.price,
      change: change ?? this.change,
      volume: volume ?? this.volume,
      marketCap: marketCap,
      market: market,
      iconColor: iconColor,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
    );
  }
}
