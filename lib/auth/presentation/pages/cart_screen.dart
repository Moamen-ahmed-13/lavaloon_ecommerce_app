// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/cart/cart_cubit.dart';
// import '../../domain/entities/product.dart'; // Import Product (adjust path; remove CartItem if unused)
// import 'checkout_screen.dart'; // Adjust path

// class CartScreen extends StatelessWidget {
//   const CartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Shopping Cart')),
//       body: BlocBuilder<CartCubit, CartState>(
//         builder: (context, state) {
//           if (state is CartLoadingState) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state is CartErrorState) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                       'Error: ${state.message}'), // FIXED: Use state.error (assume CartErrorState has error)
//                   ElevatedButton(
//                     onPressed: () => context.read<CartCubit>().loadCart(),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//           if (state is CartLoadedState) {
//             final cartItems = state
//                 .cartItems; // FIXED: List<Map<dynamic,dynamic>> (from repo, not CartItem)
//             if (cartItems.isEmpty) {
//               // Friendly empty state (no blank – with icon/message)
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.shopping_cart_outlined,
//                         size: 64, color: Colors.grey),
//                     const SizedBox(height: 16),
//                     const Text('Your cart is empty',
//                         style: TextStyle(fontSize: 18, color: Colors.grey)),
//                     const SizedBox(height: 8),
//                     const Text('Add some products to get started!'),
//                   ],
//                 ),
//               );
//             }

//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (context, index) {
//                       final item =
//                           cartItems[index]; // FIXED: Map<dynamic,dynamic>
//                       final p =
//                           item['product']; // FIXED: Map access (may be null)
//                       final qty = item['quantity'] ??
//                           1; // FIXED: Map access with default
//                       if (p == null) {
//                         print(
//                             '❌ Null product at index $index: $item'); // FIXED: Log for debug
//                         return const ListTile(
//                             title: Text(
//                                 'Invalid Item – Refresh Cart')); // FIXED: Placeholder (no crash)
//                       }
//                       final subtotal = (p.price ?? 0.0) *
//                           qty; // FIXED: Null safety for price
//                       return Card(
//                         child: ListTile(
//                           leading: Image.network(
//                             p.image ?? '',
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.contain,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Icon(Icons.image_not_supported),
//                           ),
//                           title: Text(
//                             p.name ?? 'Unknown',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ), // FIXED: Null safety
//                           subtitle: Text(
//                             'Qty: $qty | \$${subtotal.toStringAsFixed(2)} | Rating: ${(p.rate ?? 0.0).toStringAsFixed(1)}', // FIXED: Safe p.rate (API rating)
//                           ),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 onPressed: qty > 1
//                                     ? () => context
//                                         .read<CartCubit>()
//                                         .updateQuantity(
//                                             p.id ?? '',
//                                             qty -
//                                                 1) // FIXED: Null safety for id
//                                     : null,
//                                 icon: const Icon(Icons.remove),
//                               ),
//                               Text('$qty'),
//                               IconButton(
//                                 onPressed: qty <
//                                         99 // FIXED: No stock limit (arbitrary cap; remove for unlimited)
//                                     ? () => context
//                                         .read<CartCubit>()
//                                         .updateQuantity(p.id ?? '', qty + 1)
//                                     : null,
//                                 icon: const Icon(Icons.add),
//                               ),
//                               IconButton(
//                                 onPressed: () => context
//                                     .read<CartCubit>()
//                                     .removeFromCart(
//                                         p.id ?? ''), // FIXED: Null safety
//                                 icon: const Icon(Icons.delete),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 // Totals section with FutureBuilder for async getTotal
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: FutureBuilder<double>(
//                     future: context.read<CartCubit>().getTotal(
//                         tax: 0.1), // Await async getTotal (with tax example)
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const CircularProgressIndicator(); // Brief spinner for total calc
//                       }
//                       final total =
//                           snapshot.data ?? 0.0; // Fallback to 0 on error
//                       if (snapshot.hasError) {
//                         print('Total calc error: ${snapshot.error}'); // Debug
//                       }
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Total: \$${total.toStringAsFixed(2)}',
//                             style: const TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 16),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: cartItems
//                                       .isEmpty // FIXED: Use cartItems.isEmpty
//                                   ? null
//                                   : () => Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (_) => CheckoutScreen()),
//                                       ),
//                               child: const Text('Proceed to Checkout'),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () =>
//                                 context.read<CartCubit>().clearCart(),
//                             child: const Text('Clear Cart'),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//           // Fallback for initial/unknown states
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }
