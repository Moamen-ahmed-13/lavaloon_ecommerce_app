import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<ProductEntity>>> getAllProducts();
  
  Future<Either<Failure, List<ProductEntity>>> getProductsPaginated({
    required int page,
    required int limit,
  });
  
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String category);
  
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategoryPaginated({
    required String category,
    required int page,
    required int limit,
  });
  
  Future<Either<Failure, ProductEntity>> getProductById(int id);
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
}