// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/cart_repository.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/product_repository.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';

// part 'product_details_state.dart';

// // class ProductDetailsCubit extends Cubit<ProductDetailsState> {
// //   final ProductRepository productRepository  = ProductRepository();
// //   final CartRepository cartRepository = CartRepository();
// //   ProductDetailsCubit() : super(ProductDetailsInitial());

// // Future<void> addToCart(Product product, int quantity) async {
// //   try {
// //     cartRepository.addToCart(product, quantity);
// //     emit(ProductDetailsMessage("Product added to cart"));
// //   } catch (e) {
// //     emit(ProductDetailsErrorState(e.toString()));
// //   }
// // }
// //   void loadDetails(Product product) {
// //     emit(ProductDetailsLoadedState(product));
// //   }

// //   void requestAddToCart(Product product, int quantity) async {
// //     emit(ProductDetailsCartActionRequest(product, quantity));
// //   }

// //   Future<void> addToWishlist(Product product) async {
// //     try {
// //       final Box wishlistBox = await Hive.box('wishlist');
// //       wishlistBox.put(product.id, product);
// //       emit(ProductDetailsMessage("Product added to wishlist"));
// //     } catch (e) {
// //       emit(ProductDetailsErrorState(e.toString()));
// //     }
// //   }

// //   Future<void> getSimilarProducts(String category) async {
// //     emit(ProductDetailsLoadingState());
// //     try {
// //       List<Product> products =
// //           await productRepository.getSimilarProducts(category);
// //       emit(ProductDetailsLoadedSimilarState(products));
// //     } catch (e) {
// //       emit(ProductDetailsErrorState(e.toString()));
// //     }
// //   }
// // }
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:equatable/equatable.dart';
// // import 'package:hive/hive.dart';  // For wishlist
// // import '../../domain/entities/product.dart';
// // import '../../data/repositories/product_repository.dart';

// // part 'product_details_state.dart';

// class ProductDetailsCubit extends Cubit<ProductDetailsState> {
//   final ProductRepository repository = ProductRepository();

//   ProductDetailsCubit() : super(ProductDetailsInitial());

//   void loadDetails(Product product) {
//     emit(ProductDetailsLoaded(product, similarProducts: []));
//   }

//   Future<void> getSimilarProducts(String category) async {
//     final currentState = state;
//     if (currentState is ProductDetailsLoaded) {
//       emit(ProductDetailsLoading());
//       try {
//         // ✅ هنا بنجيب المنتجات من نفس الكاتيجوري
//         List<Product> allProducts = await repository.getSimilarProducts(category);

//         // ✅ بنفلترهم علشان نستبعد المنتج الحالي (ما يتكررش)
//         List<Product> similar = allProducts
//             .where((p) => p.category == category && p.id != currentState.product.id)
//             .toList();

//         emit(ProductDetailsLoaded(
//           currentState.product,
//           similarProducts: similar,
//         ));
//       } catch (e) {
//         emit(ProductDetailsError('Failed to load similar products: $e'));
//       }
//     }
//   }

//   void requestAddToCart(Product product, int quantity) {
//     emit(ProductDetailsCartActionRequested(product, quantity));
//   }

//   Future<void> addToWishlist(Product product) async {
//     try {
//       final Box wishlistBox = Hive.box('wishlist');
//       wishlistBox.put(product.id, product);
//       emit(ProductDetailsMessage('Added to wishlist'));
//     } catch (e) {
//       emit(ProductDetailsError(e.toString()));
//     }
//   }
// }
