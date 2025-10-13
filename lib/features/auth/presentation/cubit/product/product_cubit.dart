// import 'dart:convert';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/services.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/product_repository.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/domain/usecases/fetch_products.dart';

// part 'product_state.dart';

// class ProductCubit extends Cubit<ProductState> {
//   final FetchProductsUseCase fetchProduct;
//   List<Product> _originalProducts = []; // Initial API products for fallback
//   List<Product>? _fallbackProducts; // Cached 20 products from JSON file

//   ProductCubit({required this.fetchProduct}) : super(ProductsInitial()) {
//     fetchProducts(); // Initial load
//   }

//   // Load fallback products from JSON file (lazy – unchanged from previous)
//   Future<List<Product>> _loadFallbackProducts() async {
//     if (_fallbackProducts != null) return _fallbackProducts!; // Cached

//     try {
//       final String jsonString =
//           await rootBundle.loadString('assets/products.json');
//       final List<dynamic> jsonList = json.decode(jsonString);
//       _fallbackProducts = jsonList
//           .map((json) => Product.fromJson(json as Map<String, dynamic>))
//           .toList();
//       print(
//           'Loaded ${_fallbackProducts!.length} fallback products from JSON'); // Debug
//       return _fallbackProducts!;
//     } catch (e) {
//       print('Error loading fallback JSON: $e');
//       _fallbackProducts = [];
//       return [];
//     }
//   }

//   // NEW: Auto-load JSON fallback if initial API empty/fail
//   Future<void> loadFallbackIfEmpty() async {
//     final fallback = await _loadFallbackProducts();
//     if (fallback.isNotEmpty) {
//       _originalProducts = fallback; // Set as "original" if API empty
//       emit(
//           ProductsLoaded(fallback, hasMore: true)); // Enable infinite with JSON
//     } else {
//       emit(ProductsError(
//           'No products available and fallback failed. Please check connection.'));
//     }
//   }

//   Future<void> fetchProducts({int page = 1}) async {
//     emit(ProductsLoading());
//     try {
//       List<Product> newProducts = await fetchProduct.call(page: page);

//       if (page == 1) {
//         if (newProducts.isNotEmpty) {
//           _originalProducts = newProducts; // Set API as original
//           emit(ProductsLoaded(newProducts, hasMore: newProducts.length == 10));
//         } else {
//           // NEW: API empty on initial – Auto-load JSON fallback
//           await loadFallbackIfEmpty();
//         }
//         return;
//       }

//       // For page >1: Append real API if available
//       if (newProducts.isNotEmpty) {
//         final currentState = state;
//         if (currentState is ProductsLoaded) {
//           newProducts = [...currentState.products, ...newProducts];
//         }
//         emit(
//             ProductsLoaded(newProducts, hasMore: newProducts.length % 10 == 0));
//       } else {
//         // API end – Append JSON fallback (load if not cached)
//         final fallback = await _loadFallbackProducts();
//         if (fallback.isNotEmpty) {
//           final currentState = state;
//           List<Product> appended = List.from(fallback);
//           if (currentState is ProductsLoaded) {
//             appended = [...currentState.products, ...appended];
//           }
//           emit(ProductsLoaded(appended, hasMore: true)); // Infinite cycle
//         } else {
//           emit(ProductsLoaded(state.products,
//               hasMore: false)); // Stop if no fallback
//         }
//       }
//     } catch (e) {
//       // NEW: On API error (e.g., initial fail), auto-load JSON fallback
//       if (page == 1) {
//         await loadFallbackIfEmpty();
//       } else {
//         emit(ProductsError(e.toString()));
//       }
//     }
//   }

//   Future<void> searchProducts(String query) async {
//     emit(ProductsLoading());
//     try {
//       List<Product> searchResults = await fetchProduct.call(search: query);
//       if (searchResults.isEmpty && _originalProducts.isNotEmpty) {
//         emit(ProductsLoadedFallback(_originalProducts,
//             message: 'No search results found. Showing all products.'));
//       } else {
//         emit(ProductsLoaded(searchResults, hasMore: false));
//       }
//     } catch (e) {
//       emit(ProductsError(e.toString()));
//     }
//   }

//   Future<void> filterProducts(
//       {String? category, double? minPrice, double? maxPrice}) async {
//     emit(ProductsLoading());
//     try {
//       List<Product> filterResults = await fetchProduct.call(
//         category: category,
//         minPrice: minPrice,
//         maxPrice: maxPrice,
//         page: 1,
//       );
//       if (filterResults.isEmpty && _originalProducts.isNotEmpty) {
//         emit(ProductsLoadedFallback(_originalProducts,
//             message: 'No products match the filter. Showing all products.'));
//       } else {
//         emit(
//             ProductsLoaded(filterResults, hasMore: filterResults.length == 10));
//       }
//     } catch (e) {
//       emit(ProductsError(e.toString()));
//     }
//   }

//   void resetToOriginal() {
//     if (_originalProducts.isNotEmpty) {
//       emit(ProductsLoaded(_originalProducts, hasMore: true));
//     } else {
//       fetchProducts(); // Re-fetch (will fallback to JSON if empty)
//     }
//   }
// }
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/usecases/fetch_products.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final FetchProductsUseCase fetchProduct;
  List<Product> _originalProducts = [];
  List<Product>? _fallbackProducts;
  int _currentPage = 1;
  bool _isFetching = false;

  ProductCubit({required this.fetchProduct}) : super(ProductsInitial()) {
    fetchProducts();
  }

  Future<List<Product>> _loadFallbackProducts() async {
    if (_fallbackProducts != null) return _fallbackProducts!;
    try {
      final jsonString = await rootBundle.loadString('assets/products.json');
      final jsonList = json.decode(jsonString) as List;
      _fallbackProducts = jsonList
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
      return _fallbackProducts!;
    } catch (e) {
      _fallbackProducts = [];
      return [];
    }
  }

  Future<void> fetchProducts({int page = 1}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (page == 1) emit(ProductsLoading());

    try {
      final newProducts = await fetchProduct.call(page: page);

      if (newProducts.isEmpty && page == 1) {
        // لا يوجد API → استخدم fallback
        final fallback = await _loadFallbackProducts();
        if (fallback.isNotEmpty) {
          _originalProducts = fallback;
          emit(ProductsLoaded(fallback, hasMore: true));
        } else {
          emit(ProductsError('No products available.'));
        }
      } else if (newProducts.isEmpty && page > 1) {
        // لما يخلص الـ API → كرر البيانات السابقة
        final repeated = List<Product>.from(_originalProducts);
        final currentState = state;
        if (currentState is ProductsLoaded) {
          final updated = [...currentState.products, ...repeated];
          emit(ProductsLoaded(updated, hasMore: true));
        }
      } else {
        // نجاح API
        if (page == 1) {
          _originalProducts = newProducts;
          emit(ProductsLoaded(newProducts, hasMore: newProducts.length == 20));
        } else {
          final currentState = state;
          if (currentState is ProductsLoaded) {
            final updated = [...currentState.products, ...newProducts];
            emit(ProductsLoaded(updated, hasMore: newProducts.length == 20));
          }
        }
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }

    _isFetching = false;
  }

  Future<void> loadMore() async {
    _currentPage++;
    await fetchProducts(page: _currentPage);
  }

  void filterProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? query,
  }) {
    if (_originalProducts.isEmpty) return;

    List<Product> filtered = List.from(_originalProducts);

    if (category != null && category.isNotEmpty && category != 'All') {
      filtered = filtered
          .where((p) => p.category.toLowerCase() == category.toLowerCase())
          .toList();
    }

    if (query != null && query.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    if (minPrice != null) {
      filtered = filtered.where((p) => p.price >= minPrice).toList();
    }

    if (maxPrice != null) {
      filtered = filtered.where((p) => p.price <= maxPrice).toList();
    }

    emit(ProductsLoaded(filtered, hasMore: false));
  }

  void resetToOriginal() {
    if (_originalProducts.isNotEmpty) {
      emit(ProductsLoaded(_originalProducts, hasMore: true));
    } else {
      fetchProducts();
    }
  }
}
