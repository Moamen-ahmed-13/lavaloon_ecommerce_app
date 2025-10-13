// import 'dart:convert';

// import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';
// import 'package:http/http.dart' as http;

// class ProductRepository {
//   static const String baseUrl = 'https://fakestoreapi.com/products';

//   Future<List<Product>> fetchProducts(
//       {String? search,
//       String? category,
//       double? minPrice,
//       double? maxPrice,
//       int page = 1,
//       int limit = 10}) async {
//     String url = '$baseUrl?limit=$limit&offset=${(page - 1) * limit}';

//     if (search != null) {
//       url += '&q=$search';
//     }

//     if (category != null) {
//       url += '&category=$category';
//     }

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       List<Product> products = data
//           .map((json) => Product(
//               id: json['id'].toString(),
//               name: json['title'],
//               description: json['description'],
//               price: json['price'] as double,
//               rate: 100,
//               category: json['category'],
//               image: json['image']))
//           .where((product) {
//         if (minPrice != null && product.price < minPrice) {
//           return false;
//         }
//         if (maxPrice != null && product.price > maxPrice) {
//           return false;
//         }
//         if (search != null &&
//             !product.name.toLowerCase().contains(search.toLowerCase())) {
//           return false;
//         }
//         return true;
//       }).toList();
//       return products;
//     } else {
//       throw Exception('Failed to fetch products');
//     }
//   }

//   Future<List<Product>> getSimilarProducts(String category) async {
//    return fetchProducts(category: category, limit: 4);
//   }
// }
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../domain/entities/product.dart'; // Correct path

// class ProductRepository {
//   static const String baseUrl = 'https://fakestoreapi.com/products';

//   Future<List<Product>> fetchProducts({
//     String? search,
//     String? category,
//     double? minPrice, // DOUBLE?
//     double? maxPrice, // DOUBLE?
//     int page = 1,
//     int limit = 20,
//   }) async {
//     final int offset = (page - 1) * limit;
//     String url = '$baseUrl?limit=$limit&offset=$offset';
//     if (category != null)
//       url += '&category=$category'; // Fake API supports category

//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       List<Product> products =
//           data.map((json) => Product.fromJson(json)).toList();

//       // Client-side search (Fake API lacks it)
//       if (search != null && search.isNotEmpty) {
//         products = products
//             .where((p) => p.name.toLowerCase().contains(search.toLowerCase()))
//             .toList();
//       }

//       // Client-side price filter (Fake API lacks it) – DOUBLE comparisons
//       products = products.where((p) {
//         if (minPrice != null && p.price < minPrice)
//           return false; // double < double
//         if (maxPrice != null && p.price > maxPrice)
//           return false; // double > double
//         return true;
//       }).toList();

//       // Pagination: Fake API doesn't paginate perfectly; limit client-side if needed
//       if (offset > 0) {
//         products = products.skip(offset).take(limit).toList();
//       }

//       return products;
//     }
//     throw Exception('Failed to fetch products: ${response.statusCode}');
//   }

//  Future<List<Product>> getSimilarProducts(String category) async {
//   try {
//     // ✅ استخدم endpoint الفئة الصحيح
//     final response = await http.get(
//       Uri.parse('$baseUrl/category/$category'),
//     );

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.map((json) => Product.fromJson(json)).toList();
//     } else {
//       throw Exception(
//           'Failed to load similar products: ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('Error fetching similar products: $e');
//   }
// }

// }
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/product.dart';

class ProductRepository {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  }) async {
    final int offset = (page - 1) * limit;

    String url;
    if (category != null && category.isNotEmpty) {
      // ✅ استخدم endpoint الفئة
      url = '$baseUrl/category/$category';
    } else {
      url = '$baseUrl?limit=$limit';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Product> products =
          data.map((json) => Product.fromJson(json)).toList();

      // ✅ فلترة بالبحث
      if (search != null && search.isNotEmpty) {
        products = products
            .where((p) => p.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      }

      // ✅ فلترة بالسعر
      products = products.where((p) {
        if (minPrice != null && p.price < minPrice) return false;
        if (maxPrice != null && p.price > maxPrice) return false;
        return true;
      }).toList();

      // ✅ تقسيم الصفحات لو عايزها
      if (products.length > limit) {
        products = products.skip(offset).take(limit).toList();
      }

      return products;
    }

    throw Exception('Failed to fetch products: ${response.statusCode}');
  }

  Future<List<Product>> getSimilarProducts(String category) async {
    // ✅ استدعاء صحيح للفئة
    return fetchProducts(category: category, limit: 5);
  }
}
