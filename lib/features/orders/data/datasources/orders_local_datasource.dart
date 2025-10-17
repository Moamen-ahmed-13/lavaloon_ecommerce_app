import 'package:hive/hive.dart';
import 'package:lavaloon_ecommerce_app/features/orders/data/models/order_model.dart';
import 'package:lavaloon_ecommerce_app/features/orders/domain/entities/order_entity.dart';

class OrdersLocalDataSource {
  final Box ordersBox = Hive.box('orders');

  Future<void> saveOrder(OrderModel order) async {
    final orders = getOrders();
    orders.insert(0, order);
    await _saveOrders(orders);
  }

  List<OrderModel> getOrders() {
    final data = ordersBox.get('orders_list');
    if (data == null) {
      return [];
    }
    final List<dynamic> items = data as List;
    return items
        .map((item) => OrderModel.fromJson(Map<dynamic, dynamic>.from(item)))
        .toList();
  }

  OrderModel? getOrderById(String orderId) {
    final orders = getOrders();
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } on Exception catch (e) {
      return null;
    }
  }

  Future<void> updateOrderStatus(String orderId, int newStatus) async {
    final orders = getOrders();
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      final updatedOrder = OrderModel(
          id: orders[index].id,
          items: orders[index].items,
          total: orders[index].total,
          status: OrderStatus.values[newStatus],
          address: orders[index].address,
          paymentMethod: orders[index].paymentMethod,
          subtotal: orders[index].subtotal,
          tax: orders[index].tax,
          createdAt: orders[index].createdAt);
      orders[index] = updatedOrder;
      await _saveOrders(orders);
    }
  }

  Future<void> deleteOrder(String orderId) async {
    final orders = getOrders();
    orders.removeWhere((order) => order.id == orderId);
    await _saveOrders(orders);
  }

  Future<void> clearAllOrders() async {
    await ordersBox.delete('orders_list');
  }

  Future<void> _saveOrders(List<OrderModel> orders) async {
    await ordersBox.put(
        'orders_list', orders.map((order) => order.toJson()).toList());
  }

  List<OrderModel> getOrdersByStatus(OrderStatus status) {
    final orders = getOrders();
    return orders.where((order) => order.status == status).toList();
  }

  int getTotalOrdersCount() {
    final orders = getOrders();
    return orders.length;
  }

  double getTotalSpent() {
    final orders = getOrders();
    return orders.fold(0, (total, order) => total + order.total);
  }
}
