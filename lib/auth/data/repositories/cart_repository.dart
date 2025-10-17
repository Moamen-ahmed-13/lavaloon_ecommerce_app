// import 'package:hive/hive.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/cart_item.dart';
// import '../../domain/entities/product.dart';
// import 'package:hive/hive.dart';
// import '../../domain/entities/product.dart';  // Import Product (adjust path)

// class CartRepository {
//   static const String _boxName = 'cart';
//   Box get _cartBox => Hive.box(_boxName);

//   // FIXED: Async for consistency; robust parsing with null checks and logging
//   Future<List<Map<dynamic,dynamic>>> getCart() async {
//     try {
//       await Future.microtask(() {});  // Yield for box readiness
//       final List<Map<dynamic,dynamic>> cartItems = [];

//       for (final dynamic rawItem in _cartBox.values) {
//         if (rawItem == null || rawItem is! Map) {
//           print('❌ Skipping invalid rawItem: $rawItem');
//           continue;
//         }

//         final Map<dynamic,dynamic> typedItem = Map<dynamic,dynamic>.from(rawItem);
//         final productJson = typedItem['product'];

//         if (productJson == null) {
//           print('❌ Skipping item with null productJson: ${typedItem.keys}');
//           continue;
//         }

//         if (productJson is! Map<dynamic,dynamic>) {
//           print('❌ Skipping invalid productJson type: ${productJson.runtimeType}');
//           continue;
//         }

//         try {
//           final product = Product.fromJson(Map<dynamic,dynamic>.from(productJson));  // FIXED: Updated fromJson handles rating
//           final quantity = typedItem['quantity'] as int? ?? 1;

//           if (quantity > 0 && product.id.isNotEmpty && product.name.isNotEmpty) {
//             cartItems.add({
//               'product': product,  // Valid Product with rating
//               'quantity': quantity,
//             });
//             print('✅ Parsed item: ${product.name}, rating: ${product.rate}');  // FIXED: Debug rating
//           } else {
//             print('❌ Skipping invalid item: qty=$quantity, id=${product.id}, name=${product.name}');
//           }
//         } catch (e) {
//           print('❌ Error parsing cart item (JSON keys: ${productJson.keys}, error: $e');
//           continue;
//         }
//       }
//       print('✅ Cart loaded: ${cartItems.length} items');
//       return cartItems;
//     } catch (e) {
//       print('❌ Error loading cart: $e');
//       return [];
//     }
//   }

//   Future<void> addToCart(Product product, int quantity) async {
//     if (quantity <= 0 || product.id.isEmpty) {
//       print('❌ Invalid add to cart: quantity=$quantity, id=${product.id}');
//       return;
//     }

//     final id = product.id.toString();
//     final currentItem = _cartBox.get(id);

//     Map<dynamic,dynamic> newItem;
//     if (currentItem != null && currentItem is Map<dynamic,dynamic>) {
//       final currentQty = (currentItem['quantity'] as int? ?? 0) + quantity;
//       newItem = {
//         'product': product.toJson(),  // FIXED: Calls updated toJson (includes rating)
//         'quantity': currentQty,
//       };
//     } else {
//       newItem = {
//         'product': product.toJson(),  // FIXED: Valid JSON with rating
//         'quantity': quantity,
//       };
//     }

//     await _cartBox.put(id, newItem);
//     print('✅ Added/Updated: ${product.name}, qty=$quantity, rating: ${product.rate}');  // FIXED: Debug rating
//   }

//   Future<void> updateQuantity(String id, int quantity) async {
//     id = id.toString();
//     if (quantity <= 0) {
//       await removeFromCart(id);
//       return;
//     }
//     final currentItem = _cartBox.get(id);
//     if (currentItem != null && currentItem is Map<dynamic,dynamic>) {
//       final productJson = currentItem['product'];
//       if (productJson is Map<dynamic,dynamic>) {
//         await _cartBox.put(id, {
//           'product': productJson,
//           'quantity': quantity,
//         });
//         print('✅ Updated qty for $id to $quantity');
//       } else {
//         print('❌ Invalid product JSON for $id');
//       }
//     } else {
//       print('❌ No item found for $id');
//     }
//   }

//   Future<void> removeFromCart(String id) async {
//     await _cartBox.delete(id.toString());
//     print('✅ Removed item: $id');
//   }

//   Future<void> clearCart() async {
//     await _cartBox.clear();
//     print('✅ Cart cleared');
//   }

//   // FIXED: Async, caches cart for efficiency
//   Future<double> getTotal({double discountRate = 0.0, double taxRate = 0.1}) async {
//     try {
//       final cart = await getCart();  // Cache once
//       double subtotal = 0.0;
//       for (final item in cart) {
//         final product = item['product'] as Product;  // Safe after parsing
//         final qty = item['quantity'] as int;
//         subtotal += product.price * qty;
//       }
//       final discount = subtotal * discountRate;
//       final tax = (subtotal - discount) * taxRate;
//       return subtotal - discount + tax;
//     } catch (e) {
//       print('❌ Error calculating total: $e');
//       return 0.0;
//     }
//   }

//   Future<int> getItemCount() async {
//     return (await getCart()).length;
//   }
// }
