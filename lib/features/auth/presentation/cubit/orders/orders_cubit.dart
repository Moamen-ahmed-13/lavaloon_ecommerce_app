import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/order_repository.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/order.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrderRepository orderRepository = OrderRepository();
  String? userId;
  OrdersCubit({this.userId}) : super(OrdersInitial());

  Future<void> fetchOrders() async {
    emit(OrdersLoading());
    try {
      List<Orders> orders = await orderRepository.getOrders(userId ?? '');
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}
