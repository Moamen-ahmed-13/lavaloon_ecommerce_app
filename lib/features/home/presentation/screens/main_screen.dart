import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavaloon_ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/cart/presentation/pages/cart_screen.dart';
import 'package:lavaloon_ecommerce_app/features/orders/presentation/pages/orders_screen.dart';
import 'package:lavaloon_ecommerce_app/features/products/presentation/pages/products_screen.dart';
import 'package:lavaloon_ecommerce_app/features/wishlist/presentation/pages/wishlist_screen.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  
  const MainScreen({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  
  
  final List<Widget> _screens = [
    const ProductsScreen(),
    const CartScreen(),
    const WishlistScreen(),
    const OrdersScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF4CAF50),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.store),
              activeIcon: Icon(Icons.store, size: 28),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: _buildCartBadge(),
              activeIcon: _buildCartBadge(isActive: true),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: _buildWishlistBadge(),
              activeIcon: _buildWishlistBadge(isActive: true),
              label: 'Wishlist',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              activeIcon: Icon(Icons.receipt_long, size: 28),
              label: 'Orders',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartBadge({bool isActive = false}) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Badge(
          label: state.itemCount > 0 ? Text('${state.itemCount}') : null,
          isLabelVisible: state.itemCount > 0,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          child: Icon(
            Icons.shopping_cart,
            size: isActive ? 28 : 24,
          ),
        );
      },
    );
  }

  Widget _buildWishlistBadge({bool isActive = false}) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        return Badge(
          label: state.itemCount > 0 ? Text('${state.itemCount}') : null,
          isLabelVisible: state.itemCount > 0,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          child: Icon(
            Icons.favorite,
            size: isActive ? 28 : 24,
          ),
        );
      },
    );
  }
}