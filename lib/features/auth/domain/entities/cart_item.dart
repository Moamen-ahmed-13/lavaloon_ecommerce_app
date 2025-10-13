import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'product.dart';  // Adjust path to your Product entity (e.g., '../../domain/entities/product.dart')

part 'cart_item.g.dart';  // For Hive code generation (run build_runner)

@HiveType(typeId: 3)  // Unique typeId (choose unused, e.g., 1 if not conflicting with Product's typeId=0)
class CartItem extends Equatable {
  @HiveField(0)
  final Product product;

  @HiveField(1)
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  }) : assert(quantity > 0, 'Quantity must be greater than 0');  // Optional validation

  // Factory for JSON deserialization (used in CartRepository getCart)
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    product: Product.fromJson(json['product'] ?? <String, dynamic>{}),  // Fallback empty map if null
    quantity: json['quantity'] ?? 1,  // Default to 1 if missing
  );

  // toJson for serialization (used in CartRepository addToCart, etc.)
  Map<String, dynamic> toJson() => {
    'product': product.toJson(),  // Assumes Product has toJson
    'quantity': quantity,
  };

  // Equatable props (for BLoC state comparison – use product.id for efficiency if Product is heavy)
  @override
  List<Object> get props => [product.id, quantity];  // Or [product, quantity] if full equality needed
}