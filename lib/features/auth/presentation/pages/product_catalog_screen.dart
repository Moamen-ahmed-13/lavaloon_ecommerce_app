// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/product/product_cubit.dart';
// import '../../domain/entities/product.dart';
// import 'product_details_screen.dart'; // Adjust path

// class ProductCategoryScreen extends StatefulWidget {
//   @override
//   _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
// }

// class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
//   final _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   int _currentPage = 1;
//   String? _selectedCategory; // Track selected filter chip category
//   double? _minPrice, _maxPrice; // Optional: For price filter (client-side)
//   bool _isSearching = false;
//   String? _searchQuery; // Track search for combined filtering

//   // Common categories (hardcoded – or extract dynamically from products)
//   final List<String> _categories = [
//     'All', // Reset chip
//     'electronics',
//     'jewelery',
//     "men's clothing",
//     "women's clothing",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     context
//         .read<ProductCubit>()
//         .fetchProducts(); // Initial fetch (continues infinite)
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       final state = context.read<ProductCubit>().state;
//       if (state is ProductsLoaded && state.hasMore) {
//         context.read<ProductCubit>().fetchProducts(
//             page: ++_currentPage); // Load more (appends to full list)
//       }
//     }
//   }

//   // Updated: Handle FilterChip tap (client-side – no API call, just setState for rebuild)
//   void _onCategorySelected(String category) {
//     setState(() {
//       if (_selectedCategory == category) {
//         _selectedCategory = null; // Deselect
//       } else {
//         _selectedCategory =
//             category == 'All' ? null : category; // Select or reset
//       }
//     });
//   }

//   // Updated: Handle search (client-side filter after search, or combine with category)
//   void _onSearchSubmitted(String query) {
//     setState(() {
//       _searchQuery = query.isEmpty ? null : query.toLowerCase();
//       _isSearching = false;
//     });
//     if (query.isNotEmpty) {
//       // Optional: Call cubit search for API filter, then client-side
//       context.read<ProductCubit>().searchProducts(query);
//     } else {
//       context.read<ProductCubit>().resetToOriginal(); // Reset to full
//     }
//   }

//   // NEW: Client-side filter function (applies category + search + optional price)
//   List<Product> _filterProducts(List<Product> allProducts) {
//     var filtered = allProducts;

//     // Category filter
//     if (_selectedCategory != null && _selectedCategory != 'All') {
//       filtered = filtered
//           .where((p) =>
//               p.category.toLowerCase() == _selectedCategory!.toLowerCase())
//           .toList();
//     }

//     // Search filter (if active)
//     if (_searchQuery != null && _searchQuery!.isNotEmpty) {
//       filtered = filtered
//           .where((p) =>
//               p.name.toLowerCase().contains(_searchQuery!) ||
//               p.description.toLowerCase().contains(_searchQuery!))
//           .toList();
//     }

//     // Optional: Price filter (client-side – add TextFields if needed)
//     if (_minPrice != null && _minPrice! > 0) {
//       filtered = filtered.where((p) => p.price >= _minPrice!).toList();
//     }
//     if (_maxPrice != null && _maxPrice! > 0) {
//       filtered = filtered.where((p) => p.price <= _maxPrice!).toList();
//     }

//     return filtered;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: _isSearching
//             ? TextField(
//                 controller: _searchController,
//                 autofocus: true,
//                 decoration: const InputDecoration(
//                   hintText: 'Search products...',
//                   border: InputBorder.none,
//                   suffixIcon: Icon(Icons.clear),
//                 ),
//                 onSubmitted: _onSearchSubmitted, // Updated handler
//                 onChanged: (value) {
//                   if (value.isEmpty) {
//                     setState(() => _searchQuery = null);
//                     context.read<ProductCubit>().resetToOriginal();
//                   }
//                 },
//               )
//             : const Text('Products'),
//         actions: [
//           IconButton(
//             icon: Icon(_isSearching ? Icons.close : Icons.search),
//             onPressed: () {
//               setState(() => _isSearching = !_isSearching);
//               if (!_isSearching) {
//                 _searchController.clear();
//                 setState(() => _searchQuery = null);
//                 context.read<ProductCubit>().resetToOriginal();
//               }
//             },
//           ),
//           // Optional: Advanced price filter dialog
//           IconButton(
//             icon: const Icon(Icons.tune),
//             onPressed: _showPriceFilterDialog,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // FilterChip row (horizontal scrollable)
//           Container(
//             height: 50,
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: _categories.map((category) {
//                 final isSelected = _selectedCategory == category ||
//                     (category == 'All' && _selectedCategory == null);
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   child: FilterChip(
//                     label: Text(category),
//                     selected: isSelected,
//                     onSelected: (_) =>
//                         _onCategorySelected(category), // Client-side update
//                     selectedColor: Colors.blue.withOpacity(0.1),
//                     checkmarkColor: Colors.blue,
//                     backgroundColor: Colors.grey.withOpacity(0.1),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           // Main content (expanded for grid)
//           Expanded(
//             child: BlocBuilder<ProductCubit, ProductState>(
//               builder: (context, state) {
//                 if (state is ProductsLoading && state.products.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (state is ProductsError) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('Error: ${state.message}'),
//                         ElevatedButton(
//                           onPressed: () =>
//                               context.read<ProductCubit>().fetchProducts(),
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//                 final allProducts =
//                     state.products; // Full fetched list (API + JSON)
//                 final filteredProducts =
//                     _filterProducts(allProducts); // NEW: Client-side filter
//                 final hasMore = state is ProductsLoaded ? state.hasMore : false;
//                 final message = state is ProductsLoadedFallback
//                     ? (state as ProductsLoadedFallback).message
//                     : null;

//                 // NEW: Handle empty filtered (show message, but keep full list accessible)
//                 if (filteredProducts.isEmpty && allProducts.isNotEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.filter_list_off,
//                             size: 64, color: Colors.grey),
//                         const SizedBox(height: 16),
//                         const Text('No products match the current filter.',
//                             style: TextStyle(fontSize: 16, color: Colors.grey)),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () =>
//                               _onCategorySelected('All'), // Reset to all
//                           child: const Text('Show All Products'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return LayoutBuilder(
//                   builder: (context, constraints) {
//                     final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
//                     return Stack(
//                       children: [
//                         // Grid with filtered products
//                         GridView.builder(
//                           controller: _scrollController,
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: crossAxisCount,
//                             childAspectRatio: 0.8,
//                             crossAxisSpacing: 8,
//                             mainAxisSpacing: 8,
//                           ),
//                           padding: const EdgeInsets.all(8),
//                           // Infinite: Use full list length for spinner (filter applies to display)
//                           itemCount: allProducts.length + (hasMore ? 1 : 0),
//                           itemBuilder: (context, index) {
//                             if (index == allProducts.length) {
//                               return const Padding(
//                                 padding: EdgeInsets.all(16.0),
//                                 child:
//                                     Center(child: CircularProgressIndicator()),
//                               );
//                             }
//                             // NEW: Get filtered index (display only filtered items)
//                             final fullProduct = allProducts[index];
//                             if (!filteredProducts.contains(fullProduct))
//                               return const SizedBox
//                                   .shrink(); // Skip non-matching (invisible)
//                             final displayIndex =
//                                 filteredProducts.indexOf(fullProduct);
//                             final product = filteredProducts[displayIndex];
//                             return Card(
//                               child: InkWell(
//                                 onTap: () => Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (_) => ProductDetailsScreen(
//                                           product: product)),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       child: Image.network(
//                                         product.image,
//                                         fit: BoxFit.cover,
//                                         width: double.infinity,
//                                         errorBuilder:
//                                             (context, error, stackTrace) =>
//                                                 const Icon(
//                                                     Icons.image_not_supported,
//                                                     size: 50),
//                                         loadingBuilder:
//                                             (context, child, loadingProgress) {
//                                           if (loadingProgress == null)
//                                             return child;
//                                           return Center(
//                                               child:
//                                                   CircularProgressIndicator());
//                                         },
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text(
//                                             product.name,
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Text(
//                                             '\$${product.price.toStringAsFixed(2)}',
//                                             style: const TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                           Text('rate: ${product.rate}',
//                                               style: const TextStyle(
//                                                   color: Colors.orangeAccent)),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         // Fallback message (for cubit fallback, e.g., search empty)
//                         if (message != null)
//                           Positioned(
//                             top: 0,
//                             left: 0,
//                             right: 0,
//                             child: Container(
//                               color: Colors.orange.withOpacity(0.1),
//                               padding: const EdgeInsets.all(8),
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.info_outline,
//                                       color: Colors.orange),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                       child: Text(message,
//                                           style: const TextStyle(
//                                               color: Colors.orange))),
//                                   TextButton(
//                                     onPressed: () => context
//                                         .read<ProductCubit>()
//                                         .resetToOriginal(),
//                                     child: const Text('Clear'),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Optional: Price filter dialog (client-side – updates _minPrice/_maxPrice)
//   void _showPriceFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Price Filter'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               decoration: const InputDecoration(labelText: 'Min Price'),
//               keyboardType: TextInputType.number,
//               onChanged: (val) => _minPrice = double.tryParse(val),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               decoration: const InputDecoration(labelText: 'Max Price'),
//               keyboardType: TextInputType.number,
//               onChanged: (val) => _maxPrice = double.tryParse(val),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _minPrice = null;
//                 _maxPrice = null;
//               });
//               Navigator.pop(context);
//             },
//             child: const Text('Clear'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               setState(() {}); // Rebuild with price filter
//             },
//             child: const Text('Apply'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
//-------------------------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/product/product_cubit.dart';
// import '../../domain/entities/product.dart';
// import 'product_details_screen.dart'; // Adjust path to details screen

// class ProductCategoryScreen extends StatefulWidget {
//   const ProductCategoryScreen({super.key});

//   @override
//   State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
// }

// class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();

//   String selectedCategory = 'All'; // From your code
//   double minPrice = 0; // From your code
//   double maxPrice = 1000; // From your code
//   bool _isSearching = false; // For search field in AppBar

//   // Categories from your code (adjust as needed)
//   final categories = [
//     'All',
//     'jewelery',
//     'men\'s clothing',
//     'women\'s clothing',
//     'electronics',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//     context
//         .read<ProductCubit>()
//         .fetchProducts(); // Initial fetch (from your code)
//   }

//   // Infinite scroll from your code (triggers loadMore if hasMore)
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       final cubit = context.read<ProductCubit>();
//       final state = cubit.state;
//       if (state is ProductsLoaded && state.hasMore) {
//         cubit
//             .loadMore(); // From your code (or fetchProducts(page: ++_currentPage) if different)
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: _isSearching
//             ? TextField(
//                 controller: _searchController,
//                 autofocus: true,
//                 decoration: const InputDecoration(
//                   hintText: 'Search products...',
//                   border: InputBorder.none,
//                 ),
//                 onSubmitted: (query) {
//                   setState(() => _isSearching = false);
//                   // Trigger filter on submit (combines with current category/price)
//                   context.read<ProductCubit>().filterProducts(
//                         query: query,
//                         category: selectedCategory,
//                         minPrice: minPrice,
//                         maxPrice: maxPrice,
//                       );
//                 },
//               )
//             : const Text('Products'),
//         actions: [
//           IconButton(
//             icon: Icon(_isSearching ? Icons.close : Icons.search),
//             onPressed: () {
//               setState(() => _isSearching = !_isSearching);
//               if (!_isSearching) {
//                 _searchController.clear();
//               }
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () => context
//                 .read<ProductCubit>()
//                 .resetToOriginal(), // From your code
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Filter bar from your code (search, dropdown, sliders)
//           _buildFilterBar(categories),
//           // Main content (expanded for grid)
//           Expanded(
//             child: BlocBuilder<ProductCubit, ProductState>(
//               builder: (context, state) {
//                 // State handling from your code
//                 if (state is ProductsLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is ProductsLoaded) {
//                   final products = state.products;
//                   return _buildGrid(products, state.hasMore); // Your grid
//                 } else if (state is ProductsError) {
//                   return Center(
//                       child: Text(state
//                           .error)); // From your code (adjust if state.error is message)
//                 } else {
//                   return const Center(child: Text('No products')); // Fallback
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Filter bar from your code (TextField, Dropdown, Sliders)
//   Widget _buildFilterBar(List<String> categories) {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         children: [
//           // Search TextField (onChanged for real-time)
//           // TextField(
//           //   controller: _searchController,
//           //   decoration: const InputDecoration(
//           //     hintText: 'Search products...',
//           //     prefixIcon: Icon(Icons.search),
//           //   ),
//           //   onChanged: (query) {
//           //     // Real-time filter (combines with category/price)
//           //     context.read<ProductCubit>().filterProducts(
//           //           query: query,
//           //           category: selectedCategory,
//           //           minPrice: minPrice,
//           //           maxPrice: maxPrice,
//           //         );
//           //   },
//           // ),
//           // Category Dropdown + Price Sliders (from your code)
//           DropdownButton<String>(
//             value: selectedCategory,
//             isExpanded: true,
//             items: categories
//                 .map((e) =>
//                     DropdownMenuItem(value: e, child: Text(e.toString())))
//                 .toList(),
//             onChanged: (value) {
//               if (value != null) {
//                 setState(() => selectedCategory = value);
//                 // Trigger filter (combines with search/price)
//                 context.read<ProductCubit>().filterProducts(
//                       query: _searchController.text,
//                       category: selectedCategory,
//                       minPrice: minPrice,
//                       maxPrice: maxPrice,
//                     );
//               }
//             },
//           ),

//           Row(
//             children: [
//               // Dropdown for category
//               //
//               // Min Price Slider
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Min \$${minPrice.round()}'),
//                     Slider(
//                       value: minPrice,
//                       min: 0,
//                       max: 1000,
//                       divisions: 20, // 50$ steps
//                       label: minPrice.round().toString(),
//                       onChanged: (v) => setState(() => minPrice = v),
//                       onChangeEnd: (_) {
//                         // Trigger filter on end (performance)
//                         context.read<ProductCubit>().filterProducts(
//                               query: _searchController.text,
//                               category: selectedCategory,
//                               minPrice: minPrice,
//                               maxPrice: maxPrice,
//                             );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               // Max Price Slider
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Max \$${maxPrice.round()}'),
//                     Slider(
//                       value: maxPrice,
//                       min: 0,
//                       max: 1000,
//                       divisions: 20,
//                       label: maxPrice.round().toString(),
//                       onChanged: (v) => setState(() => maxPrice = v),
//                       onChangeEnd: (_) {
//                         context.read<ProductCubit>().filterProducts(
//                               query: _searchController.text,
//                               category: selectedCategory,
//                               minPrice: minPrice,
//                               maxPrice: maxPrice,
//                             );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Grid from your code (with infinite spinner)
//   Widget _buildGrid(List<Product> products, bool hasMore) {
//     return GridView.builder(
//       controller: _scrollController, // Enables infinite scroll
//       padding: const EdgeInsets.all(8),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2, // Fixed 2 columns (adjust for responsive if needed)
//         childAspectRatio: 0.8,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//       ),
//       itemCount: products.length + (hasMore ? 1 : 0), // +1 for spinner
//       itemBuilder: (context, index) {
//         // Spinner at end (from your code)
//         if (index == products.length) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         final product = products[index];
//         return Card(
//           child: InkWell(
//             // Added for tap navigation (from previous design)
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => ProductDetailsScreen(product: product)),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Image (from previous design – optional, add if needed)
//                 Expanded(
//                   child: Image.network(
//                     product.image, // Assume product has image
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                         const Icon(Icons.image_not_supported),
//                   ),
//                 ),
//                 // Product details (from your code)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       Text(
//                         product.name,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text('${product.price.toStringAsFixed(2)} \$'),
//                       Text(product.category),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/product/product_cubit.dart';
import '../../domain/entities/product.dart';
import 'product_details_screen.dart'; // Adjust path to details screen

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({super.key});

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = 'All'; // From your code
  double minPrice = 0; // From your code
  double maxPrice = 1000; // From your code
  bool _isSearching = false; // For search field in AppBar

  // Categories from your code (adjust as needed)
  final categories = [
    'All',
    'jewelery',
    'men\'s clothing',
    'electronics',
    'women\'s clothing',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context
        .read<ProductCubit>()
        .fetchProducts(); // Initial fetch (from your code)
  }

  // Infinite scroll from your code (triggers loadMore if hasMore)
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<ProductCubit>();
      final state = cubit.state;
      if (state is ProductsLoaded && state.hasMore) {
        cubit
            .loadMore(); // From your code (or fetchProducts(page: ++_currentPage) if different)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                ),
                onSubmitted: (query) {
                  setState(() => _isSearching = false);
                  // Trigger filter on submit (combines with current category/price)
                  context.read<ProductCubit>().filterProducts(
                        query: query,
                        category: selectedCategory,
                        minPrice: minPrice,
                        maxPrice: maxPrice,
                      );
                },
              )
            : const Text('Products'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() => _isSearching = !_isSearching);
              if (!_isSearching) {
                _searchController.clear();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context
                .read<ProductCubit>()
                .resetToOriginal(), // From your code
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter bar from your code (now with FilterChips instead of Dropdown)
          _buildFilterBar(categories),
          // Main content (expanded for grid)
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                // State handling from your code
                if (state is ProductsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductsLoaded) {
                  final products = state.products;
                  return _buildGrid(products, state.hasMore); // Your grid
                } else if (state is ProductsError) {
                  return Center(
                      child: Text(state
                          .error)); // From your code (adjust if state.error is message)
                } else {
                  return const Center(child: Text('No products')); // Fallback
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Filter bar from your code (TextField removed as commented; replaced Dropdown with FilterChips; kept sliders)
  Widget _buildFilterBar(List<String> categories) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // FilterChips for categories (replaces Dropdown – horizontal scrollable)
          SizedBox(
            height: 48, // Fixed height for chips row
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: categories.map((category) {
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        // Exact same logic as your dropdown onChanged
                        setState(() => selectedCategory = category);
                        context.read<ProductCubit>().filterProducts(
                              query: _searchController.text,
                              category: selectedCategory,
                              minPrice: minPrice,
                              maxPrice: maxPrice,
                            );
                      },
                      selectedColor: Colors.blue.withOpacity(0.1),
                      checkmarkColor: Colors.blue,
                      backgroundColor: Colors.grey.withOpacity(0.1),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16), // Space between chips and sliders
          // Price Sliders Row (unchanged from your code)
          Row(
            children: [
              // Min Price Slider
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Min \$${minPrice.round()}'),
                    Slider(
                      value: minPrice,
                      min: 0,
                      max: 1000,
                      divisions: 20, // 50$ steps
                      label: minPrice.round().toString(),
                      onChanged: (v) => setState(() => minPrice = v),
                      onChangeEnd: (_) {
                        // Trigger filter on end (performance) – unchanged
                        context.read<ProductCubit>().filterProducts(
                              query: _searchController.text,
                              category: selectedCategory,
                              minPrice: minPrice,
                              maxPrice: maxPrice,
                            );
                      },
                    ),
                  ],
                ),
              ),
              // Max Price Slider
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Max \$${maxPrice.round()}'),
                    Slider(
                      value: maxPrice,
                      min: 0,
                      max: 1000,
                      divisions: 20,
                      label: maxPrice.round().toString(),
                      onChanged: (v) => setState(() => maxPrice = v),
                      onChangeEnd: (_) {
                        // Trigger filter on end – unchanged
                        context.read<ProductCubit>().filterProducts(
                              query: _searchController.text,
                              category: selectedCategory,
                              minPrice: minPrice,
                              maxPrice: maxPrice,
                            );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Grid from your code (with infinite spinner) – unchanged
  Widget _buildGrid(List<Product> products, bool hasMore) {
    return GridView.builder(
      controller: _scrollController, // Enables infinite scroll
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Fixed 2 columns (adjust for responsive if needed)
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length + (hasMore ? 1 : 0), // +1 for spinner
      itemBuilder: (context, index) {
        // Spinner at end (from your code)
        if (index == products.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final product = products[index];
        return Card(
          child: InkWell(
            // Added for tap navigation (from previous design)
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductDetailsScreen(product: product)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Image (from previous design – optional, add if needed)
                Expanded(
                  child: Image.network(
                    product.image, // Assume product has image
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                  ),
                ),
                // Product details (from your code)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${product.price.toStringAsFixed(2)} \$',
                        style: TextStyle(color: Colors.green),
                      ),
                      Text(product.category,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
