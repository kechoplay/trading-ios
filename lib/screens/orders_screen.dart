import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<OrderProvider>(
            builder: (_, provider, __) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Orders', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  'Balance: ${Formatters.price(provider.balance)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ],
            ),
          ),
          bottom: const TabBar(
            tabs: [Tab(text: 'Open'), Tab(text: 'History')],
          ),
        ),
        body: Consumer<OrderProvider>(
          builder: (context, provider, _) => TabBarView(
            children: [
              _OrderList(orders: provider.openOrders, showCancel: true),
              _OrderList(orders: provider.filledOrders, showCancel: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<Order> orders;
  final bool showCancel;
  const _OrderList({required this.orders, required this.showCancel});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_rounded, size: 64, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text('No orders yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, i) => _OrderCard(order: orders[i], showCancel: showCancel),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final bool showCancel;
  const _OrderCard({required this.order, required this.showCancel});

  @override
  Widget build(BuildContext context) {
    final isBuy = order.side == OrderSide.buy;
    final sideColor = isBuy ? AppColors.gain : AppColors.loss;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isBuy ? AppColors.gainLight : AppColors.lossLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isBuy ? 'BUY' : 'SELL',
                  style: TextStyle(color: sideColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Text(order.symbol, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.type.name.toUpperCase(),
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ),
              const Spacer(),
              if (showCancel && order.status == OrderStatus.open)
                TextButton(
                  onPressed: () => context.read<OrderProvider>().cancelOrder(order.id),
                  style: TextButton.styleFrom(foregroundColor: AppColors.loss, padding: EdgeInsets.zero),
                  child: const Text('Cancel'),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Info(label: 'Qty', value: '${order.quantity}'),
              _Info(label: 'Price', value: Formatters.price(order.price)),
              _Info(label: 'Total', value: Formatters.price(order.total)),
              _Info(label: 'Time', value: Formatters.timeAgo(order.createdAt)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;
  const _Info({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }
}
