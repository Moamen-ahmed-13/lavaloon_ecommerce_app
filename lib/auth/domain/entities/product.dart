// import 'package:equatable/equatable.dart';
// import 'package:hive/hive.dart';  // For Hive annotations

// part 'product.g.dart';  // For Hive code generation

// @HiveType(typeId: 0)
// class Product extends Equatable {
//   @HiveField(0)
//   final String id;  // Index 0: String

//   @HiveField(1)
//   final String name;  // Index 1: String

//   @HiveField(2)
//   final String description;  // Index 2: String

//   @HiveField(3)
//   final double price;  // Index 3: Double (not String)

//   @HiveField(4)
//   final String image;  // Index 4: String (error here – ensure no double stored)

//   @HiveField(5)
//   final String category;  // Index 5: String

//   @HiveField(6)
//   final Map<dynamic,dynamic> rating;  // Index 6: Map

//   const Product({
//     required this.id,
//     required this.name,
//     this.description = '',
//     required this.price,
//     required this.image,
//     required this.category,
//     this.rating = const {'rate': 0.0, 'count': 0},
//   });

//   Map<dynamic,dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'description': description,
//     'price': price,  // Double
//     'image': image,  // String
//     'category': category,
//     'rating': Map<dynamic,dynamic>.from(rating),
//   };

//   factory Product.fromJson(Map<dynamic,dynamic> json) => Product(
//     id: json['id']?.toString() ?? '',
//     name: json['title'] ?? json['name'] ?? 'Unknown Product',
//     description: json['description']?.toString() ?? '',
//     price: (json['price'] as num?)?.toDouble() ?? 0.0,  // Ensures double
//     image: json['image']?.toString() ?? '',  // Ensures String (no double)
//     category: json['category']?.toString() ?? 'General',
//     rating: Map<dynamic,dynamic>.from(json['rating'] ?? {'rate': 0.0, 'count': 0}),
//   );

//   double get rate => (rating['rate'] as num?)?.toDouble() ?? 0.0;
//   int get ratingCount => rating['count'] as int? ?? 0;

//   @override
//   List<Object> get props => [id, name, price, image, rating];
// }
