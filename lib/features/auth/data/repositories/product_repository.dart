import 'dart:convert';

import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts(
      {String? search,
      String? category,
      double? minPrice,
      double? maxPrice,
      int page = 1,
      int limit = 10}) async {
    String url = '$baseUrl?limit=$limit&offset=${(page - 1) * limit}';

    if (search != null) {
      url += '&q=$search';
    }

    if (category != null) {
      url += '&category=$category';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Product> products = data
          .map((json) => Product(
              id: json['id'].toString(),
              name: json['title'],
              description: json['description'],
              price: json['price'],
              stock: 100,
              category: json['category'],
              image: json['image']))
          .where((product) {
        if (minPrice != null && product.price < minPrice) {
          return false;
        }
        if (maxPrice != null && product.price > maxPrice) {
          return false;
        }
        if (search != null &&
            !product.name.toLowerCase().contains(search.toLowerCase())) {
          return false;
        }
        return true;
      }).toList();
      return products;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<List<Product>> getSimilarProducts(String category) async {
   return fetchProducts(category: category, limit: 4);
  }
}
