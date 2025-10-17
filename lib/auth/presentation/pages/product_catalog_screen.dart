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
//     'electronics',
//     'women\'s clothing',
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
//           // Filter bar from your code (now with FilterChips instead of Dropdown)
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

//   // Filter bar from your code (TextField removed as commented; replaced Dropdown with FilterChips; kept sliders)
//   Widget _buildFilterBar(List<String> categories) {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         children: [
//           // FilterChips for categories (replaces Dropdown – horizontal scrollable)
//           SizedBox(
//             height: 48, // Fixed height for chips row
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Row(
//                 children: categories.map((category) {
//                   final isSelected = selectedCategory == category;
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                     child: FilterChip(
//                       label: Text(category),
//                       selected: isSelected,
//                       onSelected: (selected) {
//                         // Exact same logic as your dropdown onChanged
//                         setState(() => selectedCategory = category);
//                         context.read<ProductCubit>().filterProducts(
//                               query: _searchController.text,
//                               category: selectedCategory,
//                               minPrice: minPrice,
//                               maxPrice: maxPrice,
//                             );
//                       },
//                       selectedColor: Colors.blue.withOpacity(0.1),
//                       checkmarkColor: Colors.blue,
//                       backgroundColor: Colors.grey.withOpacity(0.1),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16), // Space between chips and sliders
//           // Price Sliders Row (unchanged from your code)
//           Row(
//             children: [
//               // Min Price Slider
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
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
//                         // Trigger filter on end (performance) – unchanged
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
//                   crossAxisAlignment: CrossAxisAlignment.center,
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
//                         // Trigger filter on end – unchanged
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

//   // Grid from your code (with infinite spinner) – unchanged
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
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 // Image (from previous design – optional, add if needed)
//                 Expanded(
//                   child: Image.network(
//                     product.image, // Assume product has image
//                     fit: BoxFit.contain,
//                     errorBuilder: (context, error, stackTrace) =>
//                         const Icon(Icons.image_not_supported),
//                   ),
//                 ),
//                 // Product details (from your code)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.name,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         '${product.price.toStringAsFixed(2)} \$',
//                         style: TextStyle(color: Colors.green),
//                       ),
//                       Text(product.category,
//                           style: const TextStyle(color: Colors.grey)),
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
