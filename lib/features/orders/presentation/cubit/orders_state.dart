part of 'orders_cubit.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderEntity > orders;
  OrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}
class OrderDetailsLoaded extends OrdersState {
  final OrderEntity orders;
  OrderDetailsLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}



class OrdersError extends OrdersState {
  final String message;
  OrdersError({required this.message});

  @override
  List<Object?> get props => [message];
}
