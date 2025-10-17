import 'package:equatable/equatable.dart';
import 'package:lavaloon_ecommerce_app/features/products/domain/entities/product_entity.dart';

class WishlistItemEntity extends Equatable {
  final ProductEntity product;
  final DateTime addedAt;

  const WishlistItemEntity({
    required this.product,
    required this.addedAt
    
  });  

  @override
  List<Object?> get props => [product, addedAt];
}