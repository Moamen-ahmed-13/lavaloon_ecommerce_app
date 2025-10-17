// part of 'checkout_cubit.dart';

// sealed class CheckoutState extends Equatable {
//   const CheckoutState();

//   @override
//   List<Object> get props => [];
// }

// final class CheckoutInitial extends CheckoutState {}

// class CheckoutAddressEntered extends CheckoutState
// {
//   final Addresses address;
//   CheckoutAddressEntered(this.address);
//   @override
//   List<Object> get props => [address];
// }

// class CheckoutPaymentMethodSelected extends CheckoutState
// {
//   final String paymentMethod;
//   CheckoutPaymentMethodSelected(this.paymentMethod);
//   @override
//   List<Object> get props => [paymentMethod];
// }

// class CheckoutProcessing extends CheckoutState {}

// class CheckoutPaymentSuccess extends CheckoutState {
//   final String message;
//   CheckoutPaymentSuccess(this.message);
//   @override
//   List<Object> get props => [message];
// }

// class CheckoutConfirming extends CheckoutState {}

// class CheckoutOrderConfirmed extends CheckoutState {
//   final Orders order;
//   CheckoutOrderConfirmed(this.order);
//   @override
//   List<Object> get props => [order];
// }

// class CheckoutSuccess extends CheckoutState {
//   final String message;
//   CheckoutSuccess(this.message);
//   @override
//   List<Object> get props => [message];
// }

// class CheckoutError extends CheckoutState {
//   final String message;
//   CheckoutError(this.message);
//   @override
//   List<Object> get props => [message];
// }