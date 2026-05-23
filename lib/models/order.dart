enum OrderSide { buy, sell }
enum OrderType { market, limit, stopLoss }
enum OrderStatus { open, filled, cancelled }

class Order {
  final String id;
  final String symbol;
  final OrderSide side;
  final OrderType type;
  final double quantity;
  final double price;
  final OrderStatus status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.quantity,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  double get total => quantity * price;

  Order copyWith({OrderStatus? status}) => Order(
        id: id,
        symbol: symbol,
        side: side,
        type: type,
        quantity: quantity,
        price: price,
        status: status ?? this.status,
        createdAt: createdAt,
      );
}
