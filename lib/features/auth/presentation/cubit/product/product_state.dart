// part of 'product_cubit.dart';


// abstract class ProductState extends Equatable {
//   const ProductState();
//   @override
//   List<Object> get props => [];

//   // NEW: Abstract getter for products – Allows safe access in UI without casts
//   List<Product> get products => [];  // Default empty in non-loaded states
// }

// class ProductsInitial extends ProductState {
//   @override
//   List<Product> get products => [];  // Empty
// }

// class ProductsLoading extends ProductState {
//   @override
//   List<Product> get products => [];  // Empty during load
// }

// class ProductsLoaded extends ProductState {
//   final List<Product> _products;
//   final bool hasMore;
//   const ProductsLoaded(this._products, {this.hasMore = false});

//   @override
//   List<Product> get products => _products;  // Override with actual list

//   @override
//   List<Object> get props => [_products, hasMore];
// }

// class ProductsLoadedFallback extends ProductState {
//   final List<Product> _products;
//   final String message;
//   const ProductsLoadedFallback(this._products, {required this.message});

//   @override
//   List<Product> get products => _products;  // Override with original list

//   @override
//   List<Object> get props => [_products, message];
// }

// class ProductsError extends ProductState {
//   final String message;
//   const ProductsError(this.message);

//   @override
//   List<Product> get products => [];  // Empty on error

//   @override
//   List<Object> get props => [message];
// }
part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final bool hasMore;
  const ProductsLoaded(this.products, {this.hasMore = true});

  @override
  List<Object?> get props => [products, hasMore];
}

class ProductsError extends ProductState {
  final String error;
  const ProductsError(this.error);

  @override
  List<Object?> get props => [error];
}
