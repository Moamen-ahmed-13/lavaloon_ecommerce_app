import 'package:flutter/material.dart'; // Core Flutter widgets for building the UI
import 'package:flutter_bloc/flutter_bloc.dart'; // For BLoC state management
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<
      FormState>(); // Key for form validation; ensures all fields are checked before submission
  final _nameController =
      TextEditingController(); // Controller for the name field
  final _emailController =
      TextEditingController(); // Controller for the email field
  final _passwordController =
      TextEditingController(); // Controller for the password field
  final _confirmPasswordController =
      TextEditingController(); // Controller for the confirm password field
  bool _isProcessing =
      false; // State to show loading indicator and prevent multiple submissions

  @override
  void dispose() {
    // Clean up controllers to free resources and prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar for navigation, similar to your LoginScreen
        title: const Text('Register'),
      ),
      body: SafeArea(
        // SafeArea to avoid notches or status bar overlap
        child: BlocConsumer<AuthCubit, AuthState>(
          // Listener and builder for AuthCubit states
          listener: (context, state) {
            if (state is AuthError) {
              // Handle error state (e.g., registration failed)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(state.message)), // Show error message from cubit
              );
              setState(() => _isProcessing = false); // Stop processing on error
            } else if (state is AuthRegisteredState) {
              // Handle success state (e.g., user registered)
              Navigator.pushReplacementNamed(
                  context, '/products'); // Navigate to products screen or home
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              // Show loading indicator if registration is in progress
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              // Scrollable content for forms on smaller screens
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60), // Spacer for top padding

                    // App icon or header, similar to LoginScreen
                    const Icon(
                      Icons
                          .shopping_bag, // Using the same icon as your LoginScreen for consistency
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Create an Account!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign up to get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Name Field (new addition for registration)
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person), // Icon for visual cue
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Validation: Ensure name is not empty
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Field (copied from LoginScreen with similar styling)
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Validation: Check for valid email
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field (similar to LoginScreen)
                    TextFormField(
                      controller: _passwordController,
                      obscureText:
                          true, // Hide password for security (simplified from your code)
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Validation: Ensure password meets criteria
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Field (new addition for registration)
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true, // Hide for security
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Validation: Ensure it matches password
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Register Button (similar to LoginScreen's Sign In button)
                    ElevatedButton(
                      onPressed: _isProcessing
                          ? null
                          : () {
                              // Disable if processing to prevent multiple taps
                              if (_formKey.currentState!.validate()) {
                                setState(() => _isProcessing =
                                    true); // Set processing state
                                context.read<AuthCubit>().signUp(
                                      // Call cubit's register method
                                      _emailController.text,
                                      _passwordController.text,
                                      _nameController.text,
                                    );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text(
                              'Register',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Link to Login Screen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/login'); // Navigate to login screen
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
