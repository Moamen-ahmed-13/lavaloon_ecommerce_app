import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
  
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;
  final List<String> categories;
  final String? selectedCategory;
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;
  
  const ProductsLoaded({
    required this.products,
    required this.categories,
    this.selectedCategory,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });
  
  @override
  List<Object?> get props => [
        products,
        categories,
        selectedCategory,
        currentPage,
        hasReachedMax,
        isLoadingMore,
      ];
  
  ProductsLoaded copyWith({
    List<ProductEntity>? products,
    List<String>? categories,
    String? selectedCategory,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
    bool clearCategory = false,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ProductsError extends ProductsState {
  final String message;
  
  const ProductsError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class ProductDetailsLoading extends ProductsState {}

class ProductDetailsLoaded extends ProductsState {
  final ProductEntity product;
  final List<ProductEntity> similarProducts;
  
  const ProductDetailsLoaded({
    required this.product,
    required this.similarProducts,
  });
  
  @override
  List<Object?> get props => [product, similarProducts];
}