import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/address_repository.dart';
import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/cart_repository.dart';
import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/order_repository.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/address.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/order.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';
import 'package:uuid/uuid.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final OrderRepository orderRepository = OrderRepository();
  final AddressRepository addressRepository = AddressRepository();
  final CartRepository cartRepository = CartRepository();
  String? userId;
  CheckoutCubit({this.userId}) : super(CheckoutInitial());

  Future<void> enterAddress(Addresses address) async {
    if (address.city.isEmpty ||
        address.street.isEmpty ||
        address.zipCode.isEmpty ||
        !address.isValid) {
      emit(CheckoutError("Please enter a valid address"));
      return;
    }
    emit(CheckoutAddressEntered(address));
  }

  void selectPaymentMethod(String paymentMethod) {
    emit(CheckoutPaymentMethodSelected(paymentMethod));
  }

  Future<void> processPayment(String method, double total) async {
    emit(CheckoutProcessing());
    try {
      if (method == 'cod') {
        emit(CheckoutSuccess("COD selected"));
      } else {
        final paymentIntentData = await _createPaymentIntent(total);
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData['client_secret'],
            merchantDisplayName: 'E-Commerce App',
          ),
        );
        await Stripe.instance.presentPaymentSheet();
        emit(CheckoutSuccess("Payment successful"));
      }
    } catch (e) {
      print('Payment process error: $e');  // Debug log
      emit(CheckoutError("Payment failed: ${e.toString()}"));
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(double total) async {
    // Mock – Replace with real backend API call (e.g., http.post('/create-intent', body: {'amount': (total * 100).toInt()}))
    return {
      'client_secret': '',
      'amount': total,
    };
  }

  Future<void> confirmOrder(Addresses address, String paymentMethod) async {
    emit(CheckoutConfirming());
    try {
      // Await async getCart (returns List<Map<String, dynamic>>)
      final cartItems = await cartRepository.getCart();  // FIXED: List<Map> from repo
      if (cartItems.isEmpty) {
        // Validate empty cart
        emit(CheckoutError("Cart is empty. Cannot confirm order."));
        return;
      }

      // FIXED: Filter valid items (skip null products)
      final validItems = cartItems.where((item) => item['product'] != null).toList();
      if (validItems.isEmpty) {
        emit(CheckoutError("No valid items in cart. Please refresh."));
        return;
      }

      // Await async getTotal
      final total = await cartRepository.getTotal(taxRate: 0.1);  // Example with 10% tax (adjust)

      // FIXED: Extract List<Product> from maps (safe cast, skip null)
      final orderItems = validItems
          .map((item) => item['product'] as Product)  // FIXED: Use ['product'] for Map, not .product
          .where((p) => p != null && p.id.isNotEmpty)  // FIXED: Filter null/invalid products
          .cast<Product>()
          .toList();

      if (orderItems.isEmpty) {
        emit(CheckoutError("No valid products in cart. Please refresh."));
        return;
      }

      Orders order = Orders(
        id: const Uuid().v4(),
        items: orderItems,  // List<Product> from maps
        total: total,  // Awaited value
        date: DateTime.now(),
        status: paymentMethod == 'card' ? 'paid' : 'pending',
        address: address.displayString,
      );

      await orderRepository.saveOrder(order, userId ?? '');
      await cartRepository.clearCart();  // Clear after success
      print('✅ Order confirmed: ${order.id}, total: $total, items: ${orderItems.length}');  // Debug log
      emit(CheckoutOrderConfirmed(order));
    } catch (e) {
      print('Order confirmation error: $e');  // Debug log
      emit(CheckoutError("Order confirmation failed: ${e.toString()}"));
    }
  }
}