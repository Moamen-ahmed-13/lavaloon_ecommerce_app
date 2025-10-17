import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lavaloon_ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/checkout/domain/entities/address_entity.dart';
import 'package:lavaloon_ecommerce_app/features/orders/data/datasources/orders_local_datasource.dart';
import 'package:lavaloon_ecommerce_app/features/orders/data/models/order_model.dart';
import 'package:lavaloon_ecommerce_app/features/orders/domain/entities/order_entity.dart';
import 'package:lavaloon_ecommerce_app/services/stripe_service.dart';
import 'package:uuid/uuid.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final StripeService stripeService;
  final OrdersLocalDataSource ordersDataSource;
  final CartCubit cartCubit;
  CheckoutCubit(this.stripeService, this.ordersDataSource, this.cartCubit)
      : super(CheckoutInitial());

  void startCheckout() {
    emit(CheckoutAddressStep());
  }

  void submitAddress(AddressEntity address) {
    emit(CheckoutPaymentStep(address: address));
  }

  void selectPaymentMethod(PaymentMethod paymentMethod) {
    if (state is CheckoutPaymentStep) {
      final currentState = state as CheckoutPaymentStep;
      emit(
        CheckoutPaymentStep(
            address: currentState.address,
            selectedPaymentMethod: paymentMethod),
      );
    }
  }

  Future<void> processPayment() async {
    if (state is! CheckoutPaymentStep) return;
    final currentState = state as CheckoutPaymentStep;
    emit(CheckoutProcessing());
    try {
      bool paymentSuccess = false;
      if (currentState.selectedPaymentMethod == PaymentMethod.creditCard) {
        paymentSuccess = await stripeService.makePayment(
          cartCubit.state.total,
        );
      } else {
        paymentSuccess = true;
      }

      if (paymentSuccess) {
        final order = OrderModel(
          id: const Uuid().v4(),
          items: cartCubit.state.items,
          address: currentState.address,
          paymentMethod: currentState.selectedPaymentMethod,
          subtotal: cartCubit.state.subtotal,
          tax: cartCubit.state.tax,
          total: cartCubit.state.total,
          status: currentState.selectedPaymentMethod == PaymentMethod.creditCard
              ? OrderStatus.paid
              : OrderStatus.pending,
          createdAt: DateTime.now(),
        );
        await ordersDataSource.saveOrder(order);
        await cartCubit.clearCart();
        emit(CheckoutSuccess(order: order));
      } else {
        emit(CheckoutError(message: 'Payment failed. Please try again.'));
      }
    } catch (e) {
      emit(CheckoutError(
          message: " Order confirmation failed: ${e.toString()}"));
    }
  }

  void backToAddress() {
    if (state is CheckoutPaymentStep) {
      final currentState = state as CheckoutPaymentStep;
      emit(
        CheckoutAddressStep(savedAddress: currentState.address),
      );
    }
  }
}
