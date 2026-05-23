import 'package:flutter/material.dart';
import '../models/order.dart';
import '../utils/mock_data.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  double _balance = 50000.0;

  List<Order> get orders => _orders;
  double get balance => _balance;
  List<Order> get openOrders => _orders.where((o) => o.status == OrderStatus.open).toList();
  List<Order> get filledOrders => _orders.where((o) => o.status == OrderStatus.filled).toList();

  OrderProvider() {
    _orders = List.from(MockData.sampleOrders);
  }

  void placeOrder({
    required String symbol,
    required OrderSide side,
    required OrderType type,
    required double quantity,
    required double price,
  }) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symbol: symbol,
      side: side,
      type: type,
      quantity: quantity,
      price: price,
      status: type == OrderType.market ? OrderStatus.filled : OrderStatus.open,
      createdAt: DateTime.now(),
    );

    if (side == OrderSide.buy && type == OrderType.market) {
      _balance -= order.total;
    }

    _orders.insert(0, order);
    notifyListeners();
  }

  void cancelOrder(String id) {
    _orders = _orders.map((o) {
      if (o.id == id && o.status == OrderStatus.open) {
        return o.copyWith(status: OrderStatus.cancelled);
      }
      return o;
    }).toList();
    notifyListeners();
  }
}
