import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/product_repository.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/address.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/cart_item.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/order.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/product.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/usecases/fetch_products.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/cart/cart_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/checkout/checkout_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/orders/orders_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/product/product_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/wishlist/wishlist_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/pages/auth_screen.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/pages/home_screen.dart';
import 'package:lavaloon_ecommerce_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());

  Hive.registerAdapter(OrdersAdapter());
  Hive.registerAdapter(AddressesAdapter());
  Hive.registerAdapter(CartItemAdapter());

  final productBox = await Hive.openBox('products');
  productBox.clear();
  // final addressBox = await Hive.openBox('addresses');
  // addressBox.clear();
  final cartBox = await Hive.openBox('cart');
  cartBox.clear();
  final orderBox = await Hive.openBox('orders');
  orderBox.clear();
  final wishlistBox = await Hive.openBox('wishlist');
  wishlistBox.clear();

  Stripe.publishableKey =
      'pk_test_51SHAgrPM4tmvpDxuSypEdG3uikhgY3rwGd3i1VJmVYw2E4nfvRkgtPjxBMTiuGBOsAZydHj0Uh8DEAenf6zOAJxk00GFL78Rsz';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (context) => AuthCubit()..checkSession()),
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(
            fetchProduct: FetchProductsUseCase(
                ProductRepository()), // Inject your repo/use case
          )..fetchProducts(), // Optional: Auto-fetch on app start (remove if doing in screen)
        ),
        BlocProvider<CartCubit>(create: (context) => CartCubit()),
        BlocProvider<CheckoutCubit>(create: (context) => CheckoutCubit()),
        BlocProvider<OrdersCubit>(create: (context) => OrdersCubit()),
        BlocProvider<WishlistCubit>(create: (context) => WishlistCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccessState) {
              context.read<OrdersCubit>().userId = state.user.uid;
              return HomeScreen();
            }
            return AuthScreen();
          },
        ),
      ),
    );
  }
}
