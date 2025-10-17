import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../data/datasources/wishlist_local_datasource.dart';
import '../../data/models/wishlist_item_model.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistLocalDataSource localDataSource;
  
  WishlistCubit({required this.localDataSource}) : super(const WishlistState()) {
    loadWishlist();
  }
  
  void loadWishlist() {
    final items = localDataSource.getWishlistItems();
    emit(state.copyWith(items: items));
  }
  
  Future<void> toggleWishlist(ProductEntity product) async {
    if (state.isInWishlist(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }
  
  Future<void> addToWishlist(ProductEntity product) async {
    final wishlistItem = WishlistItemModel(
      product: product,
      addedAt: DateTime.now(),
    );
    
    await localDataSource.addItem(wishlistItem);
    loadWishlist();
  }
  
  Future<void> removeFromWishlist(int productId) async {
    await localDataSource.removeItem(productId);
    loadWishlist();
  }
  
  Future<void> clearWishlist() async {
    await localDataSource.clearWishlist();
    emit(const WishlistState());
  }
  
  bool isInWishlist(int productId) {
    return localDataSource.isInWishlist(productId);
  }
}