import 'package:lavaloon_ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:lavaloon_ecommerce_app/features/products/data/models/product_model.dart';
import 'package:lavaloon_ecommerce_app/features/products/domain/entities/product_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({required super.product, required super.quantity});

  factory CartItemModel.fromJson(Map<dynamic, dynamic> json) {
    try {
      return CartItemModel(
        product:
            ProductModel.fromJson(json['product'] as Map<dynamic, dynamic>),
        quantity: json['quantity'] as int,
      );
    } catch (e) {
      print('Error in fromJson: $e'); // Log for debugging
      rethrow; // Or return a default value
    }
  }
  Map<dynamic, dynamic> toJson() => {
        'product': (product as ProductModel).toJson(),
        'quantity': quantity,
      };

  @override
  CartItemModel copyWith({ProductEntity? product, int? quantity}) =>
      CartItemModel(
          product: product ?? this.product,
          quantity: quantity ?? this.quantity);
}
