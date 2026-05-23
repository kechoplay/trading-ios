import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/asset.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class OrderSheet extends StatefulWidget {
  final Asset asset;
  final bool isBuy;
  const OrderSheet({super.key, required this.asset, required this.isBuy});

  @override
  State<OrderSheet> createState() => _OrderSheetState();
}

class _OrderSheetState extends State<OrderSheet> {
  OrderType _orderType = OrderType.market;
  final _qtyController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  bool _submitting = false;

  double get _price => double.tryParse(_priceController.text) ?? widget.asset.price;
  double get _qty => double.tryParse(_qtyController.text) ?? 0;
  double get _total => _qty * ((_orderType == OrderType.market) ? widget.asset.price : _price);

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.asset.price.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sideColor = widget.isBuy ? AppColors.gain : AppColors.loss;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  '${widget.isBuy ? 'Buy' : 'Sell'} ${widget.asset.symbol}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: sideColor),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Market price: ${Formatters.price(widget.asset.price)}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            // Order type selector
            Row(
              children: OrderType.values.map((t) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _orderType = t),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _orderType == t ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _orderType == t ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Text(
                      t.name[0].toUpperCase() + t.name.substring(1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _orderType == t ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
            // Quantity
            _Field(
              label: 'Quantity',
              controller: _qtyController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            // Price (only for limit/stop)
            if (_orderType != OrderType.market) ...[
              _Field(
                label: _orderType == OrderType.limit ? 'Limit Price' : 'Stop Price',
                controller: _priceController,
                onChanged: (_) => setState(() {}),
                prefix: '\$',
              ),
              const SizedBox(height: 12),
            ],
            // Total
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estimated Total', style: TextStyle(color: AppColors.textSecondary)),
                  Text(
                    Formatters.price(_total),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: sideColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _submitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      '${widget.isBuy ? 'Place Buy' : 'Place Sell'} Order',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_qty <= 0) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    context.read<OrderProvider>().placeOrder(
          symbol: widget.asset.symbol,
          side: widget.isBuy ? OrderSide.buy : OrderSide.sell,
          type: _orderType,
          quantity: _qty,
          price: _orderType == OrderType.market ? widget.asset.price : _price,
        );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.isBuy ? 'Buy' : 'Sell'} order placed for ${widget.asset.symbol}'),
        backgroundColor: widget.isBuy ? AppColors.gain : AppColors.loss,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? prefix;

  const _Field({required this.label, required this.controller, this.onChanged, this.prefix});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixText: prefix,
        prefixStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
