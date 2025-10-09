import 'package:hive_flutter/adapters.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';
part 'order.g.dart';
@HiveType(typeId: 1)
class Orders {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<Product> items;
  @HiveField(2)
  final double total;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String status;
  @HiveField(5)
  final String address;

  Orders({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
    required this.address,
  });
}
