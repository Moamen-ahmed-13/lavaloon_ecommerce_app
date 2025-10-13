import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final Box wishlistBox = Hive.box('wishlist');

  WishlistCubit() : super(WishlistInitial()){
    loadWishlist();
  }

  void loadWishlist() async {
    emit(WishlistLoadingState());
    try {
      final wishlist = wishlistBox.values.cast<Product>().toList();
      emit(WishlistLoadedState(wishlist));
    } catch (e) {
      emit(WishlistErrorState(e.toString()));
    }
  }

void addToWishlist(Product product) async {
    try {
      wishlistBox.put(product.id, product);
      loadWishlist();
    } catch (e) {
      emit(WishlistErrorState(e.toString()));
    }
}
  void removeFromWishlist(String id) async {
    try {
      wishlistBox.delete(id);
      loadWishlist();
    } catch (e) {
      emit(WishlistErrorState(e.toString()));
    }
  }

  void clearWishlist() async {
    try {
      wishlistBox.clear();
      loadWishlist();
    } catch (e) {
      emit(WishlistErrorState(e.toString()));
    }
  }
}
