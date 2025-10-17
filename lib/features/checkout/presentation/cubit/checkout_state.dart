part of 'checkout_cubit.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutAddressStep extends CheckoutState {
  final AddressEntity? savedAddress;
  const CheckoutAddressStep({this.savedAddress});
  @override
  List<Object?> get props => [savedAddress];
}

class CheckoutPaymentStep extends CheckoutState {
  final AddressEntity address;
  final PaymentMethod selectedPaymentMethod;
  const CheckoutPaymentStep(
      {required this.address,
      this.selectedPaymentMethod = PaymentMethod.creditCard});
  @override
  List<Object?> get props => [address, selectedPaymentMethod];
}

class CheckoutProcessing extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final OrderEntity order;
  const CheckoutSuccess({required this.order});
  @override
  List<Object?> get props => [order];
}

class CheckoutError extends CheckoutState {
  final String message;
  const CheckoutError({required this.message});
  @override
  List<Object?> get props => [message];
}
