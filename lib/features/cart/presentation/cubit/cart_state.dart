part of 'cart_cubit.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;
  final bool isCartLoading;
  const CartState({this.items = const [], this.isCartLoading = false});
double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.14; // 14% tax
  double get total => subtotal + tax;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItemEntity>? items,
    bool? isCartLoading,
  }) =>
      CartState(
        items: items ?? this.items,
        isCartLoading: isCartLoading ?? this.isCartLoading,
      );

  @override
  List<Object?> get props => [items, isCartLoading];
}

class CartInitial extends CartState {}
