import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lavaloon_ecommerce_app/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:lavaloon_ecommerce_app/features/cart/data/models/cart_item_model.dart';
import 'package:lavaloon_ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:lavaloon_ecommerce_app/features/products/domain/entities/product_entity.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartLocalDataSource cartLocalDataSource;
  CartCubit(this.cartLocalDataSource) : super(CartInitial()) {
    loadCart();
  }

  void loadCart() async {
    emit(state.copyWith(isCartLoading: true));
    final cartItems = await cartLocalDataSource.getCartItems();
    emit(state.copyWith(items: cartItems, isCartLoading: false));
  }

  Future<void> addItem(ProductEntity product, {int quantity = 1}) async {
    final item = CartItemModel(product: product, quantity: quantity);
    await cartLocalDataSource.addItem(item);
    loadCart();
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    await cartLocalDataSource.updateQuantity(productId, quantity);
    loadCart();
  }

  Future<void> removeItem(int productId) async {
    await cartLocalDataSource.removeItem(productId);
    loadCart();
  }

  Future<void> clearCart() async {
    await cartLocalDataSource.clearCart();
    emit(CartState());
  }

  void incrementQuantity(int productId) {
    final item = state.items.firstWhere((item) => item.product.id == productId);
    updateQuantity(productId, item.quantity + 1);
  }

  void decrementQuantity(int productId) {
    final item = state.items.firstWhere((item) => item.product.id == productId);
    if (item.quantity > 1) {
      updateQuantity(productId, item.quantity - 1);
    }
  }
}
