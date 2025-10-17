// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../domain/entities/product.dart';

// class ProductRepository {
//   static const String baseUrl = 'https://fakestoreapi.com/products';

//   Future<List<Product>> fetchProducts({
//     String? search,
//     String? category,
//     double? minPrice,
//     double? maxPrice,
//     int page = 1,
//     int limit = 20,
//   }) async {
//     final int offset = (page - 1) * limit;

//     String url;
//     if (category != null && category.isNotEmpty) {
//       // ✅ استخدم endpoint الفئة
//       url = '$baseUrl/category/$category';
//     } else {
//       url = '$baseUrl?limit=$limit';
//     }

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       List<Product> products =
//           data.map((json) => Product.fromJson(json)).toList();

//       // ✅ فلترة بالبحث
//       if (search != null && search.isNotEmpty) {
//         products = products
//             .where((p) => p.name.toLowerCase().contains(search.toLowerCase()))
//             .toList();
//       }

//       // ✅ فلترة بالسعر
//       products = products.where((p) {
//         if (minPrice != null && p.price < minPrice) return false;
//         if (maxPrice != null && p.price > maxPrice) return false;
//         return true;
//       }).toList();

//       // ✅ تقسيم الصفحات لو عايزها
//       if (products.length > limit) {
//         products = products.skip(offset).take(limit).toList();
//       }

//       return products;
//     }

//     throw Exception('Failed to fetch products: ${response.statusCode}');
//   }

//   Future<List<Product>> getSimilarProducts(String category) async {
//     // ✅ استدعاء صحيح للفئة
//     return fetchProducts(category: category, limit: 5);
//   }
// }
