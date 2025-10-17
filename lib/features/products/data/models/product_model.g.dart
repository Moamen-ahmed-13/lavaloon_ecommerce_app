// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<dynamic, dynamic> json) => ProductModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      category: json['category'] as String,
      rating: json['rating'] as Map<dynamic, dynamic>,
    );

Map<dynamic, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'description': instance.description,
      'category': instance.category,
      'image': instance.image,
      'rating': instance.rating,
    };

Rating _$RatingFromJson(Map<dynamic, dynamic> json) => Rating(
      rate: (json['rate'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
    );

Map<dynamic, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'rate': instance.rate,
      'count': instance.count,
    };
