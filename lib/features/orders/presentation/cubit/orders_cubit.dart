import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lavaloon_ecommerce_app/features/orders/data/datasources/orders_local_datasource.dart';
import 'package:lavaloon_ecommerce_app/features/orders/domain/entities/order_entity.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersLocalDataSource ordersDataSource;
  OrdersCubit(this.ordersDataSource) : super(OrdersInitial());

  void loadOrders() {
    emit(OrdersLoading());
    try{
      final orders = ordersDataSource.getOrders();
      emit(OrdersLoaded( orders: orders));
    }catch(e){
      emit(OrdersError(message:  "Failed to load orders: ${e.toString()}"));
    }
  }

  void loadOrderDetails(String orderId) {
    emit(OrdersLoading());
    try{
      final order = ordersDataSource.getOrderById(orderId.toString());
      if (order == null) {
        emit(OrdersError(message: "Order not found"));
      } else {
        emit(OrderDetailsLoaded(orders: order));
      }
    }catch(e){
      emit(OrdersError(message:  "Failed to load order details: ${e.toString()}"));
    
      
    }
  }
}
