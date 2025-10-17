import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/product_model.dart';

class ProductsRemoteDataSource {
  final Dio dio;
  
  ProductsRemoteDataSource({required this.dio});
  
  // Note: FakeStore API doesn't support pagination parameters,
  // so we'll fetch all products and implement client-side pagination
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await dio.get('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}');
      
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
  
  // Simulated pagination (client-side since API doesn't support it)
  Future<List<ProductModel>> getProductsPaginated({
    required int page,
    required int limit,
  }) async {
    try {
      final allProducts = await getAllProducts();
      
      // Calculate start and end indices
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;
      
      // Return empty list if we've reached the end
      if (startIndex >= allProducts.length) {
        return [];
      }
      
      // Return the paginated slice
      return allProducts.sublist(
        startIndex,
        endIndex > allProducts.length ? allProducts.length : endIndex,
      );
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
  
  // Paginated category products
  Future<List<ProductModel>> getProductsByCategoryPaginated({
    required String category,
    required int page,
    required int limit,
  }) async {
    try {
      final allProducts = await getProductsByCategory(category);
      
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;
      
      if (startIndex >= allProducts.length) {
        return [];
      }
      
      return allProducts.sublist(
        startIndex,
        endIndex > allProducts.length ? allProducts.length : endIndex,
      );
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