import 'package:flutter/material.dart'; // Core Flutter widgets for UI
import 'package:flutter_bloc/flutter_bloc.dart'; // For BLoC state management
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/auth_cubit.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _emailController =
      TextEditingController(); // Controller for email input
  bool _isProcessing = false; // State to handle loading/submission

  @override
  void dispose() {
    // Clean up to prevent memory leaks
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar for navigation, similar to other screens
        title: const Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          // SafeArea to handle screen notches
          child: BlocConsumer<AuthCubit, AuthState>(
            // Listener and builder for AuthCubit states
            listener: (context, state) {
              if (state is AuthError) {
                // Handle error state (e.g., invalid email)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)), // Show error message
                );
                setState(() => _isProcessing = false); // Stop processing
              } else if (state is AuthPasswordResetSuccess) {
                // Handle success state
                ScaffoldMessenger.of(context).showSnackBar(
                  // Show success message
                  const SnackBar(content: Text('Password reset email sent!')),
                );
                Navigator.pop(context); // Navigate back to login screen
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                // Show loading indicator if processing
                return const Center(child: CircularProgressIndicator());
              }

              return Padding(
                // Padding for better layout
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        // Header text for the screen
                        'Reset Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        // Subheader for instructions
                        'Enter your email to receive a password reset link',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 48),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email), // Icon for visual cue
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          // Validation for email
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Reset Button
                      ElevatedButton(
                        onPressed: _isProcessing
                            ? null
                            : () {
                                // Disable if processing
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isProcessing =
                                      true); // Start processing state
                                  context.read<AuthCubit>().resetPassword(
                                        // Call cubit's reset method
                                        _emailController.text.trim(),
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
                                // Show spinner during processing
                                width: 18,
                                height: 18,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                ))
                            : const Text(
                                'Reset Password',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Back to Login Link
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context); // Navigate back to login screen
                          },
                          child: const Text('Back to Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
