import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/product_repository.dart' ;
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';

class  FetchProductsUseCase {
  final ProductRepository _repository;
  const FetchProductsUseCase(this._repository);

  Future<List<Product>> call({String? search,String? category,double? minPrice,double? maxPrice,int page=1}) async{
    return await _repository.fetchProducts(search: search, category: category, minPrice: minPrice, maxPrice: maxPrice, page: page);
  }
}