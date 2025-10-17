// import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/product_repository.dart' ;
// import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';

// class  FetchProductsUseCase {
//   final ProductRepository _repository;
//   const FetchProductsUseCase(this._repository);

//   Future<List<Product>> call({String? search,String? category,double? minPrice,double? maxPrice,int page=1}) async{
//     if (minPrice != null && minPrice < 0) minPrice = 0.0;
//     if (maxPrice != null && maxPrice < 0) maxPrice = 0.0;
//     return await _repository.fetchProducts(search: search, category: category, minPrice: minPrice, maxPrice: maxPrice, page: page);
//   }
// }