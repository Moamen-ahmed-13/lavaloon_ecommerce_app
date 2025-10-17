import 'package:hive/hive.dart';
import '../models/wishlist_item_model.dart';

class WishlistLocalDataSource {
  final Box wishlistBox = Hive.box('wishlist');

  Future<void> addItem(WishlistItemModel item) async {
    final wishlistItems = getWishlistItems();

    // Check if product already exists
    final existingIndex = wishlistItems.indexWhere(
      (wishlistItem) => wishlistItem.product.id == item.product.id,
    );

    if (existingIndex >= 0) {
      // Product already in wishlist, don't add again
      return;
    }

    // Add new item
    wishlistItems.add(item);
    await _saveWishlist(wishlistItems);
  }

  Future<void> removeItem(int productId) async {
    final wishlistItems = getWishlistItems();
    wishlistItems.removeWhere((item) => item.product.id == productId);
    await _saveWishlist(wishlistItems);
  }

  Future<void> clearWishlist() async {
    await wishlistBox.delete('wishlist_items');
  }

  List<WishlistItemModel> getWishlistItems() {
    final data = wishlistBox.get('wishlist_items');
    if (data == null) return [];

    final List<dynamic> items = data as List; // Assuming data is a List

    return items
        .map((item) {
          if (item is Map) {
            // Check if it's a map
            try {
              // Convert to Map<dynamic,dynamic> and handle potential errors
              final typedMap = Map<dynamic, dynamic>.from(item);
              return WishlistItemModel.fromJson(typedMap);
            } catch (e) {
              print('Error converting item to Map<dynamic,dynamic>: $e');
              return null; // Or throw a custom error
            }
          } else {
            print('Invalid item type: $item');
            return null; // Skip invalid items
          }
        })
        .where((model) => model != null) // Filter out nulls
        .cast<WishlistItemModel>() // Ensure the list is of the correct type
        .toList();
  }

  bool isInWishlist(int productId) {
    final items = getWishlistItems();
    return items.any((item) => item.product.id == productId);
  }

  Future<void> _saveWishlist(List<WishlistItemModel> items) async {
    await wishlistBox.put(
      'wishlist_items',
      items.map((item) => item.toJson()).toList(),
    );
  }
}
