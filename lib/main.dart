import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lavaloon_ecommerce_app/features/auth/data/DataSources/auth_local_DataSource.dart';
import 'package:lavaloon_ecommerce_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/pages/login_screen.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/pages/register_screen.dart';
import 'package:lavaloon_ecommerce_app/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:lavaloon_ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/cart/presentation/pages/cart_screen.dart';
import 'package:lavaloon_ecommerce_app/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/checkout/presentation/pages/checkout_screen.dart';
import 'package:lavaloon_ecommerce_app/features/orders/data/datasources/orders_local_datasource.dart';
import 'package:lavaloon_ecommerce_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/orders/presentation/pages/order_details_screen.dart';
import 'package:lavaloon_ecommerce_app/features/orders/presentation/pages/orders_screen.dart';
import 'package:lavaloon_ecommerce_app/features/products/data/datasources/products_remote_datasource.dart';
import 'package:lavaloon_ecommerce_app/features/products/data/repositories/products_repository_impl.dart';
import 'package:lavaloon_ecommerce_app/features/products/presentation/cubit/products_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/products/presentation/pages/product_details_screen.dart';
import 'package:lavaloon_ecommerce_app/features/products/presentation/pages/products_screen.dart';
import 'package:lavaloon_ecommerce_app/features/wishlist/data/datasources/wishlist_local_datasource.dart';
import 'package:lavaloon_ecommerce_app/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/wishlist/presentation/pages/wishlist_screen.dart';
import 'package:lavaloon_ecommerce_app/firebase_options.dart';
import 'package:lavaloon_ecommerce_app/services/stripe_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('cart');
  await Hive.openBox('orders');
  await Hive.openBox('user');
  await Hive.openBox('wishlist');

  Stripe.publishableKey = '';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    final localDataSource = AuthLocalDataSource();
    final authRepository = AuthRepositoryImpl(
        firebaseAuth: firebaseAuth, localDataSource: localDataSource);

    final dio = Dio();
    final remoteDataSource = ProductsRemoteDataSource(dio: dio);
    final productsRepository =
        ProductsRepositoryImpl(remoteDataSource: remoteDataSource);

    final cartDataSource = CartLocalDataSource();

    final ordersDataSource = OrdersLocalDataSource();
    final stripeService = StripeService(dio: dio);

    final wishlistDataSource = WishlistLocalDataSource();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit(authRepository)),
        BlocProvider<ProductsCubit>(
          create: (context) =>
              ProductsCubit(productsRepository: productsRepository),
        ),
        BlocProvider<CartCubit>(create: (context) => CartCubit(cartDataSource)),
        BlocProvider(
          create: (context) =>
              WishlistCubit(localDataSource: wishlistDataSource), // ← Add this
        ),
        BlocProvider<CheckoutCubit>(
            create: (context) => CheckoutCubit(
                stripeService, ordersDataSource, context.read<CartCubit>())),
        BlocProvider<OrdersCubit>(
            create: (context) => OrdersCubit(ordersDataSource)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case '/register':
              return MaterialPageRoute(builder: (_) => const RegisterScreen());
            case '/forgot-password':
              return MaterialPageRoute(
                  builder: (_) => const ForgotPasswordScreen());
            case '/products':
              return MaterialPageRoute(builder: (_) => const ProductsScreen());
            case '/product-details':
              final productId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(productId: productId),
              );
            case '/cart':
              return MaterialPageRoute(builder: (_) => const CartScreen());
            case '/wishlist': // ← Add this
              return MaterialPageRoute(builder: (_) => const WishlistScreen());
            case '/checkout':
              return MaterialPageRoute(builder: (_) => const CheckoutScreen());
            case '/orders':
              return MaterialPageRoute(builder: (_) => const OrdersScreen());
            case '/order-details':
              final orderId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => OrderDetailsScreen(orderId: orderId),
              );
            default:
              return MaterialPageRoute(builder: (_) => const LoginScreen());
          }
        },
      ),
    );
  }
}
