import 'package:hive_flutter/adapters.dart';
import 'package:lavaloon_ecommerce_app/features/cart/data/models/cart_item_model.dart';

class CartLocalDataSource {
  final Box cartBox = Hive.box('cart');

  Future<void> addItem(CartItemModel item) async {
    final cartItems = getCartItems();

    final existingIndex = cartItems
        .indexWhere((cartItem) => cartItem.product.id == item.product.id);
    if (existingIndex >= 0) {
      cartItems[existingIndex] = cartItems[existingIndex].copyWith(
        quantity: cartItems[existingIndex].quantity + item.quantity,
      );
    } else {
      cartItems.add(item);
    }

    await _saveCart(cartItems);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final cartItems = getCartItems();
    final index =
        cartItems.indexWhere((cartItem) => cartItem.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index] = cartItems[index].copyWith(
          quantity: quantity,
        );
      }

      await _saveCart(cartItems);
    }
  }

  Future<void> removeItem(int productId) async {
    final cartItems = getCartItems();
    cartItems.removeWhere((cartItem) => cartItem.product.id == productId);
    await _saveCart(cartItems);
  }

  Future<void> clearCart() async {
    await cartBox.delete('cart_items');
  }

  List<CartItemModel> getCartItems() {
    final cartItems = cartBox.get('cart_items');
    if (cartItems == null) {
      return [];
    }
    final List<dynamic> items = cartItems as List;
    return items
        .map((item) => CartItemModel.fromJson(Map<dynamic, dynamic>.from(item)))
        .toList();
  }

  Future<void> _saveCart(List<CartItemModel> items) async {
    await cartBox.put(
        'cart_items', items.map((item) => item.toJson()).toList());
  }
}
