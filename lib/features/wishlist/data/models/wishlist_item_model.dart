import 'package:lavaloon_ecommerce_app/features/products/data/models/product_model.dart';
import 'package:lavaloon_ecommerce_app/features/wishlist/domain/entities/wishlist_item_entity.dart';

class WishlistItemModel extends WishlistItemEntity {
  const WishlistItemModel({
    required super.product,
    required super.addedAt,
  });

  factory WishlistItemModel.fromJson(Map<dynamic, dynamic> json) {
    return WishlistItemModel(
      product:
          ProductModel.fromJson(Map<dynamic, dynamic>.from(json['product'])),
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'product': (product as ProductModel).toJson(),
      'addedAt': addedAt.toIso8601String(),
    };
  }

  WishlistItemModel copyWith({
    ProductModel? product,
    DateTime? addedAt,
  }) {
    return WishlistItemModel(
      product: product ?? this.product,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
