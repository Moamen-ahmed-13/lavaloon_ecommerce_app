import 'package:flutter/material.dart';
import 'package:lavaloon_ecommerce_app/features/orders/domain/entities/order_entity.dart';

class StatusTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const StatusTimeline({required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      OrderStatus.pending,
      OrderStatus.paid,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    final currentIndex = statuses.indexOf(currentStatus);

    return Column(
      children: List.generate(statuses.length, (index) {
        final status = statuses[index];
        final isCompleted = index <= currentIndex;
        final isLast = index == statuses.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline Indicator
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted ? Colors.green : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Status Text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusText(status),
                      style: TextStyle(
                        fontWeight:
                            isCompleted ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted ? Colors.black : Colors.grey,
                      ),
                    ),
                    if (isCompleted && !isLast) const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Order Placed';
      case OrderStatus.paid:
        return 'Payment Confirmed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
