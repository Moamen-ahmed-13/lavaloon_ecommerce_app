import 'package:lavaloon_ecommerce_app/features/orders/domain/entities/order_entity.dart';

import '../../../cart/data/models/cart_item_model.dart';
import '../../../checkout/data/models/address_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.items,
    required super.address,
    required super.paymentMethod,
    required super.subtotal,
    required super.tax,
    required super.total,
    required super.status,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<dynamic, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((item) =>
              CartItemModel.fromJson(Map<dynamic, dynamic>.from(item)))
          .toList(),
      address:
          AddressModel.fromJson(Map<dynamic, dynamic>.from(json['address'])),
      paymentMethod: PaymentMethod.values[json['paymentMethod'] as int],
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: OrderStatus.values[json['status'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => (item as CartItemModel).toJson()).toList(),
      'address': (address as AddressModel).toJson(),
      'paymentMethod': paymentMethod.index,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    List<CartItemModel>? items,
    AddressModel? address,
    PaymentMethod? paymentMethod,
    double? subtotal,
    double? tax,
    double? total,
    OrderStatus? status,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      items: items ?? this.items,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
