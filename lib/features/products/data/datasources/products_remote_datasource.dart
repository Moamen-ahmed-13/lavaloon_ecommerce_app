import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/product_model.dart';

class ProductsRemoteDataSource {
  final Dio dio;
  
  // Cache all products to avoid multiple API calls
  List<ProductModel>? _cachedProducts;
  
  ProductsRemoteDataSource({required this.dio});
  
  Future<List<ProductModel>> getAllProducts() async {
    try {
      // Return cached products if available
      if (_cachedProducts != null) {
        return _cachedProducts!;
      }
      
      final response = await dio.get('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}');
      
      final List<dynamic> data = response.data;
      _cachedProducts = data.map((json) => ProductModel.fromJson(json)).toList();
      return _cachedProducts!;
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
  
  // Clear cache when needed (e.g., on refresh)
  void clearCache() {
    _cachedProducts = null;
  }
  
  // Get total count of products
  Future<int> getTotalProductsCount() async {
    final products = await getAllProducts();
    return products.length;
  }
  
  // Infinite pagination with looping
  Future<List<ProductModel>> getProductsPaginated({
    required int page,
    required int limit,
  }) async {
    try {
      final allProducts = await getAllProducts();
      final totalCount = allProducts.length;
      
      if (totalCount == 0) return [];
      
      // Calculate start index with looping
      // If we've gone past the end, loop back to the beginning
      final startIndex = ((page - 1) * limit) % totalCount;
      final endIndex = startIndex + limit;
      
      // If endIndex exceeds total count, we need to wrap around
      if (endIndex <= totalCount) {
        // Normal case: just return the slice
        return allProducts.sublist(startIndex, endIndex);
      } else {
        // Wrap around case: get items from start and beginning
        final firstPart = allProducts.sublist(startIndex, totalCount);
        final remainingCount = limit - firstPart.length;
        final secondPart = allProducts.sublist(0, remainingCount);
        return [...firstPart, ...secondPart];
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
  
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.productsByCategoryEndpoint}/$category',
      );
      
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products by category: $e');
    }
  }
  
  // Paginated category products with infinite looping
  Future<List<ProductModel>> getProductsByCategoryPaginated({
    required String category,
    required int page,
    required int limit,
  }) async {
    try {
      final allProducts = await getProductsByCategory(category);
      final totalCount = allProducts.length;
      
      if (totalCount == 0) return [];
      
      // Calculate with looping
      final startIndex = ((page - 1) * limit) % totalCount;
      final endIndex = startIndex + limit;
      
      if (endIndex <= totalCount) {
        return allProducts.sublist(startIndex, endIndex);
      } else {
        final firstPart = allProducts.sublist(startIndex, totalCount);
        final remainingCount = limit - firstPart.length;
        final secondPart = allProducts.sublist(0, remainingCount);
        return [...firstPart, ...secondPart];
      }
    } catch (e) {
      throw Exception('Failed to fetch products by category: $e');
    }
  }
  
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id',
      );
      
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }
  
  Future<List<String>> getCategories() async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}',
      );
      
      return List<String>.from(response.data);
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}