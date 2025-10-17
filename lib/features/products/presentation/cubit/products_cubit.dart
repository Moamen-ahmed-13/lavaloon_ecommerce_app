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
    }
    
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
          (categories) => emit(ProductsLoaded(
            products: products,
            categories: categories,
            currentPage: 1,
            hasReachedMax: products.length < productsPerPage,
          )),
        );
      },
    );
  }
  
  Future<void> loadMoreProducts() async {
    if (state is! ProductsLoaded) return;
    
    final currentState = state as ProductsLoaded;
    
    // Don't load if already loading or reached max
    if (currentState.isLoadingMore || currentState.hasReachedMax) return;
    
    emit(currentState.copyWith(isLoadingMore: true));
    
    final nextPage = currentState.currentPage + 1;
    
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
        final allProducts = List<ProductEntity>.from(currentState.products)
          ..addAll(newProducts);
        
        emit(currentState.copyWith(
          products: allProducts,
          currentPage: nextPage,
          hasReachedMax: newProducts.length < productsPerPage,
          isLoadingMore: false,
        ));
      },
    );
  }
  
  Future<void> filterByCategory(String? category) async {
    if (state is! ProductsLoaded) return;
    
    final currentState = state as ProductsLoaded;
    emit(ProductsLoading());
    
    if (category == null || category == 'All') {
      final result = await productsRepository.getProductsPaginated(
        page: 1,
        limit: productsPerPage,
      );
      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (products) => emit(currentState.copyWith(
          products: products,
          selectedCategory: null,
          currentPage: 1,
          hasReachedMax: products.length < productsPerPage,
          clearCategory: true,
        )),
      );
    } else {
      final result = await productsRepository.getProductsByCategoryPaginated(
        category: category,
        page: 1,
        limit: productsPerPage,
      );
      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (products) => emit(currentState.copyWith(
          products: products,
          selectedCategory: category,
          currentPage: 1,
          hasReachedMax: products.length < productsPerPage,
        )),
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
        hasReachedMax: true, // Search results don't support pagination
      )),
    );
  }
  
  Future<void> loadProductDetails(int productId) async {
    emit(ProductDetailsLoading());
    
    final productResult = await productsRepository.getProductById(productId);
    
    productResult.fold(
      (failure) => emit(ProductsError(failure.message)),
      (product) async {
        // Get similar products from same category
        final similarResult = await productsRepository.getProductsByCategory(product.category);
        
        similarResult.fold(
          (failure) => emit(ProductDetailsLoaded(
            product: product,
            similarProducts: [],
          )),
          (similarProducts) {
            // Remove the current product from similar products
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