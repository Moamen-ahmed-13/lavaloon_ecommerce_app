part of 'wishlist_cubit.dart';

sealed class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

final class WishlistInitial extends WishlistState {}

final class WishlistLoadingState extends WishlistState {}

final class WishlistLoadedState extends WishlistState {
  final List<Product> products;
  final bool hasMore;
  const WishlistLoadedState(this.products, {this.hasMore = false});

  @override
  List<Object> get props => [products];
}

final class WishlistErrorState extends WishlistState {
  final String message;
  const WishlistErrorState(this.message);

  @override
  List<Object> get props => [message];
}
