import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;
  
  ProductsRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts() async {
    try {
      final products = await remoteDataSource.getAllProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsPaginated({
    required int page,
    required int limit,
  }) async {
    try {
      final products = await remoteDataSource.getProductsPaginated(
        page: page,
        limit: limit,
      );
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String category) async {
    try {
      final products = await remoteDataSource.getProductsByCategory(category);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategoryPaginated({
    required String category,
    required int page,
    required int limit,
  }) async {
    try {
      final products = await remoteDataSource.getProductsByCategoryPaginated(
        category: category,
        page: page,
        limit: limit,
      );
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) async {
    try {
      final allProducts = await remoteDataSource.getAllProducts();
      final filteredProducts = allProducts.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
      return Right(filteredProducts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}