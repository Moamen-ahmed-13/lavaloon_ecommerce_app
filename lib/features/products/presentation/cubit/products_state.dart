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
  final bool isLoadingMore;
  final int totalProductsCount; // Total count of all products available
  final bool isLooping; // Indicates if we're in a loop cycle
  
  const ProductsLoaded({
    required this.products,
    required this.categories,
    this.selectedCategory,
    this.currentPage = 1,
    this.isLoadingMore = false,
    this.totalProductsCount = 0,
    this.isLooping = false,
  });
  
  @override
  List<Object?> get props => [
        products,
        categories,
        selectedCategory,
        currentPage,
        isLoadingMore,
        totalProductsCount,
        isLooping,
      ];
  
  ProductsLoaded copyWith({
    List<ProductEntity>? products,
    List<String>? categories,
    String? selectedCategory,
    int? currentPage,
    bool? isLoadingMore,
    int? totalProductsCount,
    bool? isLooping,
    bool clearCategory = false,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalProductsCount: totalProductsCount ?? this.totalProductsCount,
      isLooping: isLooping ?? this.isLooping,
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