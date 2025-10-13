part of 'orders_cubit.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

final class OrdersInitial extends OrdersState {}

final class OrdersLoaded extends OrdersState {
  final List<Orders > orders;
  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

final class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);

  @override
  List<Object> get props => [message];
}

final class OrdersLoading extends OrdersState {}
