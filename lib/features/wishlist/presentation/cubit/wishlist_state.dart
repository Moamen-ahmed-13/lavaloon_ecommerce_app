import 'package:equatable/equatable.dart';
import '../../domain/entities/wishlist_item_entity.dart';

class WishlistState extends Equatable {
  final List<WishlistItemEntity> items;
  final bool isLoading;
  
  const WishlistState({
    this.items = const [],
    this.isLoading = false,
  });
  
  int get itemCount => items.length;
  
  bool isInWishlist(int productId) {
    return items.any((item) => item.product.id == productId);
  }
  
  WishlistState copyWith({
    List<WishlistItemEntity>? items,
    bool? isLoading,
  }) {
    return WishlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  @override
  List<Object?> get props => [items, isLoading];
}