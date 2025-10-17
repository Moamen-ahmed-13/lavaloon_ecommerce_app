import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavaloon_ecommerce_app/features/products/presentation/widgets/category_chip.dart';
import 'package:lavaloon_ecommerce_app/features/products/presentation/widgets/product_card.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().loadProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductsCubit>().loadMoreProducts();
    }
    if (_scrollController.offset > 400 && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
    } else if (_scrollController.offset <= 400 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Load when 90% scrolled
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _refreshProducts() async {
    // Show loading message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing products...'),
        duration: Duration(milliseconds: 800),
      ),
    );

    // Refresh products
    await context.read<ProductsCubit>().loadProducts(refresh: true);

    // Scroll to top
    if (_scrollController.hasClients) {
      _scrollToTop();
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Products refreshed!'),
            ],
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF4CAF50), // Green color
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Products'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh products',
            onPressed: () async {
              await context.read<ProductsCubit>().loadProducts(refresh: true);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Products refreshed!'),
                    duration: Duration(seconds: 1),
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                );
              }
            },
          ),
          // Wishlist Icon (without badge for now)
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: 'Wishlist',
            onPressed: () {
              Navigator.pushNamed(context, '/wishlist');
            },
          ),
          // Cart Icon
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Cart',
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          // Cart Icon
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Orders',
            onPressed: () {
              Navigator.pushNamed(context, '/orders');
            },
          ),
          // Logout Icon
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<ProductsCubit>()
                              .loadProducts(refresh: true);
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
                context.read<ProductsCubit>().searchProducts(value);
              },
            ),
          ),

          // Category Filter
          BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoaded) {
                return SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      CategoryChip(
                        label: 'All',
                        isSelected: state.selectedCategory == null,
                        onTap: () {
                          context.read<ProductsCubit>().filterByCategory(null);
                        },
                      ),
                      ...state.categories.map((category) {
                        return CategoryChip(
                          label: category,
                          isSelected: state.selectedCategory == category,
                          onTap: () {
                            context
                                .read<ProductsCubit>()
                                .filterByCategory(category);
                          },
                        );
                      }).toList(),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 8),

          // Products Grid with Infinite Scroll
          Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
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
                                .loadProducts(refresh: true);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(
                      child: Text('No products found'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<ProductsCubit>()
                          .loadProducts(refresh: true);
                    },
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.64,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: state.hasReachedMax
                          ? state.products.length
                          : state.products.length +
                              1, // +1 for loading indicator
                      itemBuilder: (context, index) {
                        // Show loading indicator at the end
                        if (index >= state.products.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return ProductCard(product: state.products[index]);
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
