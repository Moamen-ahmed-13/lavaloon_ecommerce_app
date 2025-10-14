import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/cart/cart_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/product_details/product_details_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/wishlist/wishlist_cubit.dart';
import '../../domain/entities/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsCubit()
        ..loadDetails(product)
        ..getSimilarProducts(product.category),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductDetailsCubit, ProductDetailsState>(
            listenWhen: (previous, current) =>
                current is ProductDetailsCartActionRequested,
            listener: (context, state) {
              if (state is ProductDetailsCartActionRequested) {
                context
                    .read<CartCubit>()
                    .addToCart(state.product, state.quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Added to cart')),
                );
              }
            },
          ),
          BlocListener<ProductDetailsCubit, ProductDetailsState>(
            listenWhen: (previous, current) =>
                current is ProductDetailsMessage &&
                current.message.contains('wishlist'),
            listener: (context, state) {
              if (state is ProductDetailsMessage) {
                context.read<WishlistCubit>().loadWishlist();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(title: Text(product.name)),
          body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
            builder: (context, state) {
              if (state is ProductDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProductDetailsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('❌ Error: ${state.message}'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => context
                            .read<ProductDetailsCubit>()
                            .loadDetails(product),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is ProductDetailsLoaded) {
                final product = state.product;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Image Carousel
                      CarouselSlider(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.3,
                          autoPlay: true,
                          enlargeCenterPage: true,
                        ),
                        items: [product.image]
                            .map((img) => Image.network(
                                  img,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ))
                            .toList(),
                      ),

                      // ✅ Product Info
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(product.description),
                            const SizedBox(height: 8),
                            Text(
                              '\$${product.price}',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text('⭐ ${product.rate}'),
                                const SizedBox(width: 5),
                                const Text('(rating)'),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ✅ Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.shopping_cart),
                                    label: const Text('Add to Cart'),
                                    onPressed: () => context
                                        .read<CartCubit>()
                                        .addToCart(product, 1),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.favorite_border),
                                    label: const Text('Wishlist'),
                                    onPressed: () => context
                                        .read<WishlistCubit>()
                                        .addToWishlist(product),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),
                            const Divider(thickness: 1),
                            const SizedBox(height: 8),

                            // ✅ Similar Products Section
                            const Text(
                              'Similar Products',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),

                            BlocBuilder<ProductDetailsCubit,
                                ProductDetailsState>(
                              buildWhen: (previous, current) =>
                                  current is ProductDetailsLoaded,
                              builder: (context, innerState) {
                                if (innerState is ProductDetailsLoaded &&
                                    innerState.similarProducts.isEmpty) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          'No similar products available.'),
                                    ),
                                  );
                                }

                                if (innerState is ProductDetailsLoaded) {
                                  return SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          innerState.similarProducts.length,
                                      itemBuilder: (context, index) {
                                        final similar =
                                            innerState.similarProducts[index];
                                        return GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ProductDetailsScreen(
                                                product: similar,
                                              ),
                                            ),
                                          ),
                                          child: Card(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Container(
                                              width: 140,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.network(
                                                        similar.image,
                                                        fit: BoxFit.contain,
                                                        width: double.infinity,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(similar.name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                    '\$${similar.price}',
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }

                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
