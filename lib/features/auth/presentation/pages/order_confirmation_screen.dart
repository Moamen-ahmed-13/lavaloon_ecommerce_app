import 'package:flutter/material.dart';
import '../../domain/entities/order.dart';
import 'home_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
   Orders order;

   OrderConfirmationScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmed')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              const Text('Thank you for your order!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Order ID: ${order.id.substring(0, 8)}...'),
              Text('Total: \$${order.total.toStringAsFixed(2)}'),
              Text('Status: ${order.status.toUpperCase()}'),
              Text('Items: ${order.items.length}'),
              const SizedBox(height: 16),
              Text('Delivery to: ${order.address}'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                ),
                child: const Text('Back to Home'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/orders'),  // Or push to OrdersHistoryScreen
                child: const Text('View Orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}