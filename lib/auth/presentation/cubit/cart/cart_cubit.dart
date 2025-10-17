// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/cart_repository.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/cart_item.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';

// part 'cart_state.dart';


// class CartCubit extends Cubit<CartState> {
//   final CartRepository cartRepository = CartRepository();

//   CartCubit() : super(CartInitial()) {
//     loadCart();  // FIXED: Auto-load on creation (like your commented code)
//   }

//   Future<void> loadCart() async {
//     emit(CartLoadingState());
//     try {
//       final cart = await cartRepository.getCart();  // Now returns List<CartItem>
//       print('Cart loaded: ${cart.length} items');  // Debug: Confirm emission
//       emit(CartLoadedState(cart));  // UPDATED: CartLoadedState with List<CartItem>
//     } catch (e) {
//       print('Cart load error: $e');  // Debug
//       // FIXED: Emit empty loaded state on error (prevents stuck loading)
//       emit(CartLoadedState([]));  // Show empty cart + error message in UI
//       // Optional: emit(CartErrorState(e.toString())); if you want separate error state
//     }
//   }

//   Future<void> addToCart(Product product, int quantity) async {
//     try {
//       await cartRepository.addToCart(product, quantity);
//       // FIXED: Emit updated cart immediately (no full reload needed)
//       final updatedCart = await cartRepository.getCart();  // List<CartItem>
//       print('Added to cart: ${product.name}, total items: ${updatedCart.length}');  // Debug
//       emit(CartLoadedState(updatedCart));  // UPDATED: With List<CartItem>
//     } catch (e) {
//       print('Add to cart error: $e');
//       // FIXED: Emit empty loaded on error (consistent with loadCart)
//       emit(CartLoadedState([]));
//     }
//   }

//   Future<void> updateQuantity(String id, int quantity) async {
//     try {
//       if (quantity <= 0) {
//         await removeFromCart(id);
//         return;
//       }
//       await cartRepository.updateQuantity(id, quantity);
//       // FIXED: Emit updated immediately
//       final updatedCart = await cartRepository.getCart();  // List<CartItem>
//       emit(CartLoadedState(updatedCart));  // UPDATED: With List<CartItem>
//     } catch (e) {
//       print('Update quantity error: $e');
//       // FIXED: Emit empty loaded on error
//       emit(CartLoadedState([]));
//     }
//   }

//   Future<void> removeFromCart(String id) async {
//     try {
//       await cartRepository.removeFromCart(id);
//       // FIXED: Emit updated immediately
//       final updatedCart = await cartRepository.getCart();  // List<CartItem>
//       emit(CartLoadedState(updatedCart));  // UPDATED: With List<CartItem>
//     } catch (e) {
//       print('Remove from cart error: $e');
//       // FIXED: Emit empty loaded on error
//       emit(CartLoadedState([]));
//     }
//   }

//   Future<void> clearCart() async {
//     try {
//       await cartRepository.clearCart();
//       // FIXED: Emit empty state immediately
//       emit(CartLoadedState([]));  // UPDATED: Empty List<CartItem>
//     } catch (e) {
//       print('Clear cart error: $e');
//       // FIXED: Emit empty loaded on error
//       emit(CartLoadedState([]));
//     }
//   }

//   // UPDATED: Made async to match repo's async getTotal (awaits for error handling)
//   Future<double> getTotal({double discount = 0, double tax = 0.0}) async {
//     try {
//       return await cartRepository.getTotal(discountRate: discount, taxRate: tax);
//     } catch (e) {
//       print('Get total error: $e');
//       return 0.0;  // Fallback to 0 on error
//     }
//   }
//  }
