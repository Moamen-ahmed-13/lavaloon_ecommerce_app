// import 'package:hive_flutter/adapters.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';

// class CartRepository {
//   Box cartBox = Hive.box('cart');

//   void addToCart(Product product, int quantity) {
//     String key = product.id.toString();
//     Map<String, dynamic> cartItem = {
//       'product': product,
//       'quantity': quantity,
//     };
//     cartBox.put(key, cartItem);
//   }

//   List<Map<String, dynamic>> getCartItems() =>
//       cartBox.values.cast<Map<String, dynamic>>().toList();

//   void updateQuantity(String id, int quantity) {
//     if (quantity <= 0) {
//       return removeFromCart(id);
//     } else {
//       var item = cartBox.get(id);
//       if (item != null) {
//         item['quantity'] = quantity;
//         cartBox.put(id, item);
//       }
//     }
//   }

//   void removeFromCart(String id) {
//     cartBox.delete(id);
//   }

//   void clearCart() {
//     cartBox.clear();
//   }

//   double getTotal({double discount = 0, double tax = 0.1}) {
//     double subtotal = 0;
//     for (var item in getCartItems()) {
//       subtotal += item['product'].price * item['quantity'];
//     }
//     return subtotal * (1 - discount) * (1 + tax);
//   }
// }
// import 'package:hive/hive.dart';
// import '../../domain/entities/product.dart';  // Adjust path

// class CartRepository {
//   static const String _boxName = 'cart';
//   Box get _cartBox => Hive.box(_boxName);  // Access existing – no open/init

//   List<Map<String, dynamic>> getCart() {
//     try {
//       final List<Map<String, dynamic>> cartItems = [];
//       for (final dynamic rawItem in _cartBox.values) {
//         if (rawItem is! Map) continue;

//         final Map<String, dynamic> typedItem = Map<String, dynamic>.from(rawItem);
//         final productJson = typedItem['product'];

//         if (productJson is Map<String, dynamic>) {
//           final product = Product.fromJson(productJson);
//           final quantity = typedItem['quantity'] as int? ?? 1;

//           cartItems.add({
//             'product': product,
//             'quantity': quantity,
//           });
//         }
//       }
//       return cartItems;
//     } catch (e) {
//       print('Error loading cart: $e');
//       return [];
//     }
//   }

//   void addToCart(Product product, int quantity) {
//     final id = product.id;
//     final currentItem = _cartBox.get(id);
//     Map<String, dynamic> newItem;

//     if (currentItem != null) {
//       final currentQty = (currentItem['quantity'] as int? ?? 0) + quantity;
//       newItem = {
//         'product': product.toJson(),
//         'quantity': currentQty,
//       };
//     } else {
//       newItem = {
//         'product': product.toJson(),
//         'quantity': quantity,
//       };
//     }

//     _cartBox.put(id, newItem);
//   }
//   void updateQuantity(String id, int quantity) {
//     if (quantity <= 0) {
//       removeFromCart(id);
//       return;
//     }
//     final currentItem = _cartBox.get(id);
//     if (currentItem != null) {
//       // Reuse existing product JSON
//       final productJson = currentItem['product'];
//       _cartBox.put(id, {
//         'product': productJson,  // Keep JSON
//         'quantity': quantity,
//       });
//     }
//   }

//   void removeFromCart(String id) {
//     _cartBox.delete(id);
//   }

//   void clearCart() {
//     _cartBox.clear();
//   }

//   double getTotal({double discountRate = 0.0, double taxRate = 0.1}) {
//     double subtotal = 0.0;
//     for (final item in getCart()) {
//       final product = item['product'] as Product;
//       final qty = item['quantity'] as int;
//       subtotal += product.price * qty;
//     }
//     final discount = subtotal * discountRate;
//     final tax = (subtotal - discount) * taxRate;
//     return subtotal - discount + tax;
//   }

//   int getItemCount() => getCart().length;
// }
import 'package:hive/hive.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';

// class CartRepository {
//   static const String _boxName = 'cart';
//   Box get _cartBox => Hive.box(_boxName);

//   List<Map<String, dynamic>> getCart() {
//     try {
//       final List<Map<String, dynamic>> cartItems = [];

//       for (final dynamic rawItem in _cartBox.values) {
//         if (rawItem is! Map) continue;

//         final Map<String, dynamic> typedItem =
//             Map<String, dynamic>.from(rawItem);
//         final productJson = typedItem['product'];

//         if (productJson is Map) {
//           final product =
//               Product.fromJson(Map<String, dynamic>.from(productJson));
//           final quantity = typedItem['quantity'] as int? ?? 1;

//           cartItems.add({
//             'product': product,
//             'quantity': quantity,
//           });
//         }
//       }
//       return cartItems;
//     } catch (e) {
//       print('❌ Error loading cart: $e');
//       return [];
//     }
//   }

//   Future<void> addToCart(Product product, int quantity) async {
//     final id = product.id.toString();
//     final currentItem = _cartBox.get(id);
//     Map<String, dynamic> newItem;

//     if (currentItem != null) {
//       final currentQty = (currentItem['quantity'] as int? ?? 0) + quantity;
//       newItem = {
//         'product': product.toJson(),
//         'quantity': currentQty,
//       };
//     } else {
//       newItem = {
//         'product': product.toJson(),
//         'quantity': quantity,
//       };
//     }

//     await _cartBox.put(id, newItem);
//   }

//   Future<void> updateQuantity(String id, int quantity) async {
//     id = id.toString();
//     if (quantity <= 0) {
//       await removeFromCart(id);
//       return;
//     }
//     final currentItem = _cartBox.get(id);
//     if (currentItem != null) {
//       final productJson = currentItem['product'];
//       await _cartBox.put(id, {
//         'product': productJson,
//         'quantity': quantity,
//       });
//     }
//   }

//   Future<void> removeFromCart(String id) async {
//     await _cartBox.delete(id.toString());
//   }

//   Future<void> clearCart() async {
//     await _cartBox.clear();
//   }

//   double getTotal({double discountRate = 0.0, double taxRate = 0.1}) {
//     double subtotal = 0.0;
//     for (final item in getCart()) {
//       final product = item['product'] as Product;
//       final qty = item['quantity'] as int;
//       subtotal += product.price * qty;
//     }
//     final discount = subtotal * discountRate;
//     final tax = (subtotal - discount) * taxRate;
//     return subtotal - discount + tax;
//   }

//   int getItemCount() => getCart().length;
// }
import 'package:hive/hive.dart';
import '../../domain/entities/product.dart';  // Import Product (adjust path)

class CartRepository {
  static const String _boxName = 'cart';
  Box get _cartBox => Hive.box(_boxName);

  // FIXED: Async for consistency; robust parsing with null checks and logging
  Future<List<Map<String, dynamic>>> getCart() async {
    try {
      await Future.microtask(() {});  // Yield for box readiness
      final List<Map<String, dynamic>> cartItems = [];

      for (final dynamic rawItem in _cartBox.values) {
        if (rawItem == null || rawItem is! Map) {
          print('❌ Skipping invalid rawItem: $rawItem');
          continue;
        }

        final Map<String, dynamic> typedItem = Map<String, dynamic>.from(rawItem);
        final productJson = typedItem['product'];

        if (productJson == null) {
          print('❌ Skipping item with null productJson: ${typedItem.keys}');
          continue;
        }

        if (productJson is! Map<String, dynamic>) {
          print('❌ Skipping invalid productJson type: ${productJson.runtimeType}');
          continue;
        }

        try {
          final product = Product.fromJson(Map<String, dynamic>.from(productJson));  // FIXED: Updated fromJson handles rating
          final quantity = typedItem['quantity'] as int? ?? 1;

          if (quantity > 0 && product.id.isNotEmpty && product.name.isNotEmpty) {
            cartItems.add({
              'product': product,  // Valid Product with rating
              'quantity': quantity,
            });
            print('✅ Parsed item: ${product.name}, rating: ${product.rate}');  // FIXED: Debug rating
          } else {
            print('❌ Skipping invalid item: qty=$quantity, id=${product.id}, name=${product.name}');
          }
        } catch (e) {
          print('❌ Error parsing cart item (JSON keys: ${productJson.keys}, error: $e');
          continue;
        }
      }
      print('✅ Cart loaded: ${cartItems.length} items');
      return cartItems;
    } catch (e) {
      print('❌ Error loading cart: $e');
      return [];
    }
  }

  Future<void> addToCart(Product product, int quantity) async {
    if (quantity <= 0 || product.id.isEmpty) {
      print('❌ Invalid add to cart: quantity=$quantity, id=${product.id}');
      return;
    }

    final id = product.id.toString();
    final currentItem = _cartBox.get(id);

    Map<String, dynamic> newItem;
    if (currentItem != null && currentItem is Map<String, dynamic>) {
      final currentQty = (currentItem['quantity'] as int? ?? 0) + quantity;
      newItem = {
        'product': product.toJson(),  // FIXED: Calls updated toJson (includes rating)
        'quantity': currentQty,
      };
    } else {
      newItem = {
        'product': product.toJson(),  // FIXED: Valid JSON with rating
        'quantity': quantity,
      };
    }

    await _cartBox.put(id, newItem);
    print('✅ Added/Updated: ${product.name}, qty=$quantity, rating: ${product.rate}');  // FIXED: Debug rating
  }

  Future<void> updateQuantity(String id, int quantity) async {
    id = id.toString();
    if (quantity <= 0) {
      await removeFromCart(id);
      return;
    }
    final currentItem = _cartBox.get(id);
    if (currentItem != null && currentItem is Map<String, dynamic>) {
      final productJson = currentItem['product'];
      if (productJson is Map<String, dynamic>) {
        await _cartBox.put(id, {
          'product': productJson,
          'quantity': quantity,
        });
        print('✅ Updated qty for $id to $quantity');
      } else {
        print('❌ Invalid product JSON for $id');
      }
    } else {
      print('❌ No item found for $id');
    }
  }

  Future<void> removeFromCart(String id) async {
    await _cartBox.delete(id.toString());
    print('✅ Removed item: $id');
  }

  Future<void> clearCart() async {
    await _cartBox.clear();
    print('✅ Cart cleared');
  }

  // FIXED: Async, caches cart for efficiency
  Future<double> getTotal({double discountRate = 0.0, double taxRate = 0.1}) async {
    try {
      final cart = await getCart();  // Cache once
      double subtotal = 0.0;
      for (final item in cart) {
        final product = item['product'] as Product;  // Safe after parsing
        final qty = item['quantity'] as int;
        subtotal += product.price * qty;
      }
      final discount = subtotal * discountRate;
      final tax = (subtotal - discount) * taxRate;
      return subtotal - discount + tax;
    } catch (e) {
      print('❌ Error calculating total: $e');
      return 0.0;
    }
  }

  Future<int> getItemCount() async {
    return (await getCart()).length;
  }
}