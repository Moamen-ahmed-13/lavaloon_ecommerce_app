import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavaloon_ecommerce_app/features/products/domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository productsRepository;
  static const int productsPerPage = 6; // Load 6 products at a time
  
  ProductsCubit({required this.productsRepository}) : super(ProductsInitial());
  
  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      emit(ProductsLoading());
      productsRepository.clearCache(); // Clear cache on refresh
    }
    
    // Get total count first
    final countResult = await productsRepository.getTotalProductsCount();
    
    final productsResult = await productsRepository.getProductsPaginated(
      page: 1,
      limit: productsPerPage,
    );
    final categoriesResult = await productsRepository.getCategories();
    
    productsResult.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) {
        categoriesResult.fold(
          (failure) => emit(ProductsError(failure.message)),
          (categories) {
            countResult.fold(
              (failure) => emit(ProductsError(failure.message)),
              (totalCount) => emit(ProductsLoaded(
                products: products,
                categories: categories,
                currentPage: 1,
                isLoadingMore: false,
                totalProductsCount: totalCount,
                isLooping: false,
              )),
            );
          },
        );
      },
    );
  }
  
  Future<void> loadMoreProducts() async {
    if (state is! ProductsLoaded) return;
    
    final currentState = state as ProductsLoaded;
    
    // Don't load if already loading
    if (currentState.isLoadingMore) return;
    
    emit(currentState.copyWith(isLoadingMore: true));
    
    final nextPage = currentState.currentPage + 1;
    
    // Check if we're looping (going past the total count)
    final totalLoadedSoFar = currentState.currentPage * productsPerPage;
    final isLooping = totalLoadedSoFar >= currentState.totalProductsCount;
    
    Either result;
    
    if (currentState.selectedCategory == null) {
      result = await productsRepository.getProductsPaginated(
        page: nextPage,
        limit: productsPerPage,
      );
    } else {
      result = await productsRepository.getProductsByCategoryPaginated(
        category: currentState.selectedCategory!,
        page: nextPage,
        limit: productsPerPage,
      );
    }
    
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (newProducts) {
        // Always add products - they'll loop from the beginning if needed
        final allProducts = List<ProductEntity>.from(currentState.products)
          ..addAll(newProducts);
        
        emit(currentState.copyWith(
          products: allProducts,
          currentPage: nextPage,
          isLoadingMore: false,
          isLooping: isLooping,
        ));
      },
    );
  }
  
  Future<void> filterByCategory(String? category) async {
    if (state is! ProductsLoaded) return;
    
    final currentState = state as ProductsLoaded;
    emit(ProductsLoading());
    
    if (category == null || category == 'All') {
      // Get total count for all products
      final countResult = await productsRepository.getTotalProductsCount();
      final result = await productsRepository.getProductsPaginated(
        page: 1,
        limit: productsPerPage,
      );
      
      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (products) {
          countResult.fold(
            (failure) => emit(ProductsError(failure.message)),
            (totalCount) => emit(currentState.copyWith(
              products: products,
              selectedCategory: null,
              currentPage: 1,
              isLoadingMore: false,
              totalProductsCount: totalCount,
              clearCategory: true,
            )),
          );
        },
      );
    } else {
      // Get category products and count
      final allCategoryProductsResult = await productsRepository.getProductsByCategory(category);
      final result = await productsRepository.getProductsByCategoryPaginated(
        category: category,
        page: 1,
        limit: productsPerPage,
      );
      
      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (products) {
          allCategoryProductsResult.fold(
            (failure) => emit(ProductsError(failure.message)),
            (allCategoryProducts) => emit(currentState.copyWith(
              products: products,
              selectedCategory: category,
              currentPage: 1,
              isLoadingMore: false,
              totalProductsCount: allCategoryProducts.length,
            )),
          );
        },
      );
    }
  }
  
  Future<void> searchProducts(String query) async {
    if (state is! ProductsLoaded) return;
    
    final currentState = state as ProductsLoaded;
    
    if (query.isEmpty) {
      loadProducts(refresh: true);
      return;
    }
    
    emit(ProductsLoading());
    
    final result = await productsRepository.searchProducts(query);
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(currentState.copyWith(
        products: products,
        currentPage: 1,
        isLoadingMore: false,
        totalProductsCount: products.length,
      )),
    );
  }
  
  Future<void> loadProductDetails(int productId) async {
    emit(ProductDetailsLoading());
    
    final productResult = await productsRepository.getProductById(productId);
    
    productResult.fold(
      (failure) => emit(ProductsError(failure.message)),
      (product) async {
        final similarResult = await productsRepository.getProductsByCategory(product.category);
        
        similarResult.fold(
          (failure) => emit(ProductDetailsLoaded(
            product: product,
            similarProducts: [],
          )),
          (similarProducts) {
            final filtered = similarProducts.where((p) => p.id != productId).take(4).toList();
            emit(ProductDetailsLoaded(
              product: product,
              similarProducts: filtered,
            ));
          },
        );
      },
    );
  }
}