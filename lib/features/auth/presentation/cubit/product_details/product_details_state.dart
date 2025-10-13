part of 'product_details_cubit.dart';


abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();
  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final Product product;
  final List<Product> similarProducts;  // Optional list (empty initially)
  const ProductDetailsLoaded(this.product, {this.similarProducts = const []});
  @override
  List<Object?> get props => [product, similarProducts];
}

class ProductDetailsMessage extends ProductDetailsState {
  final String message;
  const ProductDetailsMessage(this.message);
  @override
  List<Object?> get props => [message];
}

class ProductDetailsError extends ProductDetailsState {
  final String message;
  const ProductDetailsError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProductDetailsCartActionRequested extends ProductDetailsState {
  final Product product;
  final int quantity;
  const ProductDetailsCartActionRequested(this.product, this.quantity);
  @override
  List<Object?> get props => [product, quantity];
}