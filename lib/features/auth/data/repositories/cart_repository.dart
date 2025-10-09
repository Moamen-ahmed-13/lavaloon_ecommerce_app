import 'package:hive_flutter/adapters.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';

class CartRepository {
  Box cartBox = Hive.box('cart');

  void addToCart(Product product, int quantity) {
    String key = product.id.toString();
    Map<String, dynamic> cartItem = {
      'product': product,
      'quantity': quantity,
    };
    cartBox.put(key, cartItem);
  }

  List<Map<String, dynamic>> getCartItems() =>
      cartBox.values.cast<Map<String, dynamic>>().toList();

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      return removeFromCart(id);
    } else {
      var item = cartBox.get(id);
      if (item != null) {
        item['quantity'] = quantity;
        cartBox.put(id, item);
      }
    }
  }

  void removeFromCart(String id) {
    cartBox.delete(id);
  }

  void clearCart() {
    cartBox.clear();
  }

  double getTotal({double discount = 0, double tax = 0.1}) {
    double subtotal = 0;
    for (var item in getCartItems()) {
      subtotal += item['product'].price * item['quantity'];
    }
    return subtotal * (1 - discount) * (1 + tax);
  }
}
