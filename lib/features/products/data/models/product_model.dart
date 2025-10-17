import 'package:json_annotation/json_annotation.dart';
import 'package:lavaloon_ecommerce_app/features/products/domain/entities/product_entity.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.image,
    required super.category,
    required super.rating,
  });

  factory ProductModel.fromJson(Map<dynamic, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<dynamic, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<dynamic, dynamic> json) => Rating(
        rate: (json['rate'] as num).toDouble(),
        count: (json['count'] as num).toInt(),
      );

  Map<dynamic, dynamic> toJson() => {
        'rate': rate,
        'count': count,
      };
}
