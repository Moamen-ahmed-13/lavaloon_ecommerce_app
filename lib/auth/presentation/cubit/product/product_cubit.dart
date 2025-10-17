// import 'dart:convert';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/services.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/domain/usecases/fetch_products.dart';

// part 'product_state.dart';

// class ProductCubit extends Cubit<ProductState> {
//   final FetchProductsUseCase fetchProduct;
//   List<Product> _originalProducts = [];
//   List<Product>? _fallbackProducts;
//   int _currentPage = 1;
//   bool _isFetching = false;

//   ProductCubit({required this.fetchProduct}) : super(ProductsInitial()) {
//     fetchProducts();
//   }

//   Future<List<Product>> _loadFallbackProducts() async {
//     if (_fallbackProducts != null) return _fallbackProducts!;
//     try {
//       final jsonString = await rootBundle.loadString('assets/products.json');
//       final jsonList = json.decode(jsonString) as List;
//       _fallbackProducts = jsonList
//           .map((json) => Product.fromJson(json as Map<dynamic,dynamic>))
//           .toList();
//       return _fallbackProducts!;
//     } catch (e) {
//       _fallbackProducts = [];
//       return [];
//     }
//   }

//   Future<void> fetchProducts({int page = 1}) async {
//     if (_isFetching) return;
//     _isFetching = true;

//     if (page == 1) emit(ProductsLoading());

//     try {
//       final newProducts = await fetchProduct.call(page: page);

//       if (newProducts.isEmpty && page == 1) {
//         // لا يوجد API → استخدم fallback
//         final fallback = await _loadFallbackProducts();
//         if (fallback.isNotEmpty) {
//           _originalProducts = fallback;
//           emit(ProductsLoaded(fallback, hasMore: true));
//         } else {
//           emit(ProductsError('No products available.'));
//         }
//       } else if (newProducts.isEmpty && page > 1) {
//         // لما يخلص الـ API → كرر البيانات السابقة
//         final repeated = List<Product>.from(_originalProducts);
//         final currentState = state;
//         if (currentState is ProductsLoaded) {
//           final updated = [...currentState.products, ...repeated];
//           emit(ProductsLoaded(updated, hasMore: true));
//         }
//       } else {
//         // نجاح API
//         if (page == 1) {
//           _originalProducts = newProducts;
//           emit(ProductsLoaded(newProducts, hasMore: newProducts.length == 20));
//         } else {
//           final currentState = state;
//           if (currentState is ProductsLoaded) {
//             final updated = [...currentState.products, ...newProducts];
//             emit(ProductsLoaded(updated, hasMore: newProducts.length == 20));
//           }
//         }
//       }
//     } catch (e) {
//       emit(ProductsError(e.toString()));
//     }

//     _isFetching = false;
//   }

//   Future<void> loadMore() async {
//     _currentPage++;
//     await fetchProducts(page: _currentPage);
//   }

//   void filterProducts({
//     String? category,
//     double? minPrice,
//     double? maxPrice,
//     String? query,
//   }) {
//     if (_originalProducts.isEmpty) return;

//     List<Product> filtered = List.from(_originalProducts);

//     if (category != null && category.isNotEmpty && category != 'All') {
//       filtered = filtered
//           .where((p) => p.category.toLowerCase() == category.toLowerCase())
//           .toList();
//     }

//     if (query != null && query.isNotEmpty) {
//       filtered = filtered
//           .where((p) =>
//               p.name.toLowerCase().contains(query.toLowerCase()) ||
//               p.description.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }

//     if (minPrice != null) {
//       filtered = filtered.where((p) => p.price >= minPrice).toList();
//     }

//     if (maxPrice != null) {
//       filtered = filtered.where((p) => p.price <= maxPrice).toList();
//     }

//     emit(ProductsLoaded(filtered, hasMore: false));
//   }

//   void resetToOriginal() {
//     if (_originalProducts.isNotEmpty) {
//       emit(ProductsLoaded(_originalProducts, hasMore: true));
//     } else {
//       fetchProducts();
//     }
//   }
// }
