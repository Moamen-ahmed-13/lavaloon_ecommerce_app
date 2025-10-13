import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/pages/orders_history_screen.dart';
import 'wishlist_screen.dart';
import 'auth_screen.dart'; // For logout redirect

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AuthErrorState || state is AuthInitial) {
            return Column(
              children: [
                const Center(child: Text('Not logged in. Please log in.')),
               SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AuthScreen()),
                  ),
                  child: const Text('Log In'),
                ),
              ],
            );
          }
          if (state is AuthSuccessState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          state.user.email!.isNotEmpty
                              ? state.user.email![0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                              fontSize: 32, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, ${state.user.email}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            // Text('Member since: ${state.user.createdAt?.toString().substring(0, 10) ?? 'N/A'}'),  // Assume User has createdAt
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Options List
                  ListTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text('Wishlist'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => WishlistScreen()),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Order History'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OrdersHistoryScreen()),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to settings screen (e.g., edit profile, addresses)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings coming soon!')),
                      );
                    },
                  ),
                  const Spacer(),
                  // Logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.read<AuthCubit>().logout(),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is AuthErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => context.read<AuthCubit>().checkSession(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
