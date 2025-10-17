import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavaloon_ecommerce_app/features/orders/domain/entities/order_entity.dart';

class OrderConfirmationWidget extends StatelessWidget {
  final OrderEntity order;

  const OrderConfirmationWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Success Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
          ),

          const SizedBox(height: 24),

          // Success Message
          const Text(
            'Order Placed Successfully!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Thank you for your purchase',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 32),

          // Order Details Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(
                    label: 'Order ID',
                    value: order.id.substring(0, 8).toUpperCase(),
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'Date',
                    value: DateFormat('MMM dd, yyyy').format(order.createdAt),
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'Status',
                    value: order.status.name.toUpperCase(),
                    valueColor: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'Payment Method',
                    value: order.paymentMethod == PaymentMethod.creditCard
                        ? 'Credit Card'
                        : 'Cash on Delivery',
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'Total Amount',
                    value: '\$${order.total.toStringAsFixed(2)}',
                    valueColor: Colors.green,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Delivery Address Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(order.address.fullName),
                  Text(order.address.phone),
                  Text(order.address.street),
                  Text(
                      '${order.address.city}, ${order.address.state} ${order.address.zipCode}'),
                  Text(order.address.country),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Items Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.product.title} x${item.quantity}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/orders',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View My Orders',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/products',
                  (route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue Shopping',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
