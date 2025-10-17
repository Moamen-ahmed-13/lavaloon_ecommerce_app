import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lavaloon_ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/products/presentation/cubit/products_state.dart';
import 'package:lavaloon_ecommerce_app/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/wishlist/presentation/cubit/wishlist_state.dart';
import '../cubit/products_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<ProductsCubit>()
        .loadProductDetails(widget.productId); // Convert productId to int ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProductsCubit>()
                            .loadProductDetails(widget.productId);
                      },
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
                    // Image Carousel
                    LayoutBuilder(builder: (context, constraints) {
                      return CarouselSlider(
                        options: CarouselOptions(
                          height: 300,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                        ),
                        items: [product.image, product.image, product.image]
                            .map((imageUrl) {
                          return CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                          );
                        }).toList(),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Product Info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Category
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.category.toUpperCase(),
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Rating
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 24),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(reviews)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Price
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Description
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Similar Products
                          if (state.similarProducts.isNotEmpty) ...[
                            const Text(
                              'Similar Products',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.similarProducts.length,
                                itemBuilder: (context, index) {
                                  final similarProduct =
                                      state.similarProducts[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailsScreen(
                                            productId: similarProduct.id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 150,
                                      margin: const EdgeInsets.only(right: 12),
                                      child: Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: CachedNetworkImage(
                                                imageUrl: similarProduct.image,
                                                width: double.infinity,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    similarProduct.title,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    '\$${similarProduct.price}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],

                          const SizedBox(
                              height: 100), // Space for bottom buttons
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: Builder(builder: (context) {
          return BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Error loading product details'),
                      ElevatedButton(
                        onPressed: () => context
                            .read<ProductsCubit>()
                            .loadProductDetails(widget.productId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              if (state is ProductDetailsLoaded) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Add to Wishlist Button
                      BlocBuilder<WishlistCubit, WishlistState>(
                        builder: (context, wishlistState) {
                          final isInWishlist =
                              wishlistState.isInWishlist(state.product.id);

                          return OutlinedButton(
                            onPressed: () {
                              context
                                  .read<WishlistCubit>()
                                  .toggleWishlist(state.product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isInWishlist
                                        ? 'Removed from wishlist'
                                        : 'Added to wishlist!',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Icon(
                              isInWishlist
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isInWishlist ? Colors.red : Colors.grey,
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 12),

                      // Add to Cart Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<CartCubit>().addItem(state.product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to cart!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Add to Cart'),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        }));
  }
}
