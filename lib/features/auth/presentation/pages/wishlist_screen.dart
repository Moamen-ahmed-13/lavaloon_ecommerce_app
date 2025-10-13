import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/cart/cart_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/wishlist/wishlist_cubit.dart';
import 'product_details_screen.dart';

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => context.read<WishlistCubit>().clearWishlist(),
          ),
        ],
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WishlistErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<WishlistCubit>().loadWishlist(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is WishlistLoadedState) {
            if (state.products.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Your wishlist is empty',
                        style: TextStyle(fontSize: 18)),
                    Text('Start adding items from products!'),
                  ],
                ),
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount =
                    constraints.maxWidth > 600 ? 2 : 1; // Responsive grid
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Card(
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsScreen(product: product)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 200,
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.scaleDown,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: IconButton(
                                    icon: const Icon(Icons.favorite,
                                        color: Colors.red),
                                    onPressed: () => context
                                        .read<WishlistCubit>()
                                        .removeFromWishlist(product.id),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text('\$${product.price}'),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide.none,
                                        shadowColor: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<CartCubit>()
                                            .addToCart(product, 1);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Added to cart from wishlist')),
                                        );
                                      },
                                      child: const Text('Add to Cart'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const Center(child: Text('No wishlist items'));
        },
      ),
    );
  }
}
