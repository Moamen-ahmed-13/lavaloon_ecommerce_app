import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/order.dart';

class OrderRepository {
  Box orderBox = Hive.box('orders');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveOrder(Orders order, String userId) async {
    orderBox.add(order);

    await _firestore.collection('users/$userId/orders').add({
      'id': order.id,
      'total': order.total,
      'items': order.items
          .map((item) => {'name': item.name, 'price': item.price})
          .toList(),
      'date': order.date,
      'status': order.status,
      'address': order.address,
    });
  }

  Future<List<Orders>> getOrders(String userId) async {
    QuerySnapshot snapshot =
        await _firestore.collection('users/$userId/orders').get();

    return snapshot.docs
        .map((doc) => Orders(
              id: doc['id'],
              total: doc['total'],
              items: [],
              status: doc['status'],
              address: doc['address'],
              date: (doc['date'] as Timestamp).toDate(),
            ))
        .toList();
  }
}
