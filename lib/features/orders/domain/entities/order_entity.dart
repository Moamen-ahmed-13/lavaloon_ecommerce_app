import 'package:equatable/equatable.dart';
import 'package:lavaloon_ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:lavaloon_ecommerce_app/features/checkout/domain/entities/address_entity.dart';

enum OrderStatus {
  pending,
  paid,
  shipped,
  delivered,
  cancelled,
}

enum PaymentMethod {
  creditCard,
  cashOnDelivery,
}

class OrderEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final AddressEntity address;
  final PaymentMethod paymentMethod;
  final double subtotal;
  final double tax;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.address,
    required this.paymentMethod,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        items,
        address,
        paymentMethod,
        subtotal,
        tax,
        total,
        status,
        createdAt,
      ];
}
