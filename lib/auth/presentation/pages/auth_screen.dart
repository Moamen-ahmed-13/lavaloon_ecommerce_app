// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/auth/auth_cubit.dart';
// import 'home_screen.dart'; // Navigate to home on success

// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   bool isLogin = true;
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool rememberMe = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
//       body: BlocListener<AuthCubit, AuthState>(
//         listener: (context, state) {
//           if (state is AuthSuccessState) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => HomeScreen()),
//             );
//           }
//           if (state is AuthErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//           if (state is AuthMessage) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 100),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(labelText: 'Email'),
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(labelText: 'Password'),
//                 ),
//                 const SizedBox(height: 16),
//                 if (isLogin)
//                   CheckboxListTile(
//                     title: const Text('Remember Me'),
//                     value: rememberMe,
//                     onChanged: (val) =>
//                         setState(() => rememberMe = val ?? false),
//                   ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (isLogin) {
//                       context.read<AuthCubit>().login(
//                             _emailController.text,
//                             _passwordController.text,
//                             rememberMe: rememberMe,
//                           );
//                     } else {
//                       context.read<AuthCubit>().register(
//                             _emailController.text,
//                             _passwordController.text,
//                           );
//                     }
//                   },
//                   child: Text(isLogin ? 'Login' : 'Register'),
//                 ),
//                 const SizedBox(height: 16),
//                 TextButton(
//                   onPressed: () => setState(() => isLogin = !isLogin),
//                   child:
//                       Text(isLogin ? 'Switch to Register' : 'Switch to Login'),
//                 ),
//                 if (isLogin)
//                   TextButton(
//                     onPressed: () => context
//                         .read<AuthCubit>()
//                         .forgotPassword(_emailController.text),
//                     child: const Text('Forgot Password?'),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }
