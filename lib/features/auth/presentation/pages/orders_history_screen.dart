import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/orders/orders_cubit.dart';
import '../../domain/entities/order.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  _OrdersHistoryScreenState createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  @override
  void initState() {
    super.initState();
    final userId = (context.read<AuthCubit>().state is AuthSuccessState)
        ? (context.read<AuthCubit>().state as AuthSuccessState).user.uid
        : null;
    if (userId != null) {
      context.read<OrdersCubit>().userId = userId;  // Set userId
      context.read<OrdersCubit>().fetchOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrdersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => context.read<OrdersCubit>().fetchOrders(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('No orders yet. Start shopping!'));
            }
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(order.status),
                      child: Text(order.status[0].toUpperCase()),
                    ),
                    title: Text('Order #${order.id.substring(0, 8)}'),
                    subtitle: Text('${order.date.toString().substring(0, 10)} • \$${order.total.toStringAsFixed(2)}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showOrderDetails(context, order),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No orders'));
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'delivered':
        return Colors.blue;
      case 'shipped':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showOrderDetails(BuildContext context, Orders order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #${order.id.substring(0, 8)}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Date: ${order.date.toString().substring(0, 16)}'),
              Text('Total: \$${order.total.toStringAsFixed(2)}'),
              Text('Status: ${order.status.toUpperCase()}'),
              const SizedBox(height: 8),
              const Text('Address:'),
              Text(order.address),
              const SizedBox(height: 8),
              const Text('Items:'),
              ...order.items.map((p) => Text('- ${p.name} (\$${p.price})')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}