// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/auth/auth_cubit.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/cart/cart_cubit.dart';
// import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/checkout/checkout_cubit.dart';
// import '../../data/repositories/address_repository.dart';
// import '../../domain/entities/address.dart';
// import '../../domain/entities/product.dart';
// import 'order_confirmation_screen.dart';

// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({Key? key}) : super(key: key);

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final _addressRepo = AddressRepository();

//   // Stepper state
//   int _currentStep = 0;

//   // Forms & controllers
//   final _addressFormKey = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _streetController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _zipController = TextEditingController();
//   final _countryController = TextEditingController(text: 'USA');

//   // Addresses
//   List<Addresses> _savedAddresses = [];
//   Addresses? _selectedSavedAddress;
//   Addresses? _pickedAddress; // final address used for order

//   // Payment
//   String? _paymentMethod; // 'card' or 'cod'
//   CardFieldInputDetails? _card; // stripe card data

//   // Loading / error
//   bool _loadingAddresses = true;
//   String? _addressesError;
//   bool _processing = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedAddresses();
//   }

//   Future<void> _loadSavedAddresses() async {
//     setState(() {
//       _loadingAddresses = true;
//       _addressesError = null;
//     });
//     try {
//       final addresses = await _addressRepo.getSavedAddresses();
//       // try to get default if exists
//       final defaultAddr = await _addressRepo.getDefaultAddress();
//       setState(() {
//         _savedAddresses = addresses;
//         if (defaultAddr.id.isNotEmpty) {
//           _selectedSavedAddress = addresses.firstWhere(
//             (a) => a.id == defaultAddr.id,
//             orElse: () => defaultAddr,
//           );
//           _applySavedAddress(_selectedSavedAddress);
//         }
//         _loadingAddresses = false;
//       });
//     } catch (e) {
//       setState(() {
//         _addressesError = e.toString();
//         _loadingAddresses = false;
//       });
//     }
//   }

//   void _applySavedAddress(Addresses? a) {
//     if (a == null) return;
//     _selectedSavedAddress = a;
//     _pickedAddress = a;
//     _fullNameController.text = a.fullName ?? '';
//     _phoneController.text = a.phone ?? '';
//     _streetController.text = a.street ?? '';
//     _cityController.text = a.city ?? '';
//     _stateController.text = a.state ?? '';
//     _zipController.text = a.zipCode ?? '';
//     _countryController.text = a.country ?? 'USA';
//   }

//   // Compute total via CartCubit — uses Future in case getTotal is async
//   Future<double> _computeTotal() async {
//     final cartCubit = context.read<CartCubit>();
//     final totalMaybeFuture = cartCubit.getTotal(tax: 0.1);
//     if (totalMaybeFuture is Future<double>) {
//       return await totalMaybeFuture;
//     } else if (totalMaybeFuture is double) {
//       return totalMaybeFuture;
//     } else {
//       // fallback: try synchronous getter on repository or return 0
//       return 0.0;
//     }
//   }
//   // Shared continue handler (used by bottom button)
//   Future<void> _onStepContinue() async {
//     if (_processing) return;
//     // ensure mounted after awaited ops
//     if (_currentStep == 0) {
//       // validate address form (if no saved address chosen)
//       if (_selectedSavedAddress == null) {
//         if (!_addressFormKey.currentState!.validate()) return;
//         // build Addresses instance from controllers
//         _pickedAddress = Addresses.create(
//           fullName: _fullNameController.text,
//           phone: _phoneController.text,
//           street: _streetController.text,
//           city: _cityController.text,
//           state: _stateController.text,
//           zipCode: _zipController.text,
//           country: _countryController.text,
//         );
//       } else {
//         // use selectedSavedAddress as picked
//         _pickedAddress = _selectedSavedAddress;
//       }

//       // optionally save address if user checked (UI could include checkbox)
//       // In this version we saved earlier via _saveAddressNow if needed
//       // proceed
//       setState(() => _currentStep = 1);
//       return;
//     }

//     if (_currentStep == 1) {
//       // require payment method
//       if (_paymentMethod == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select a payment method')),
//         );
//         return;
//       }

//       // if card payment, ensure card details are available
//       if (_paymentMethod == 'card' && (_card == null || !_card!.complete)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please enter valid card details')),
//         );
//         return;
//       }

//       // compute total
//       double total = 0.0;
//       try {
//         total = await _computeTotal();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Error calculating total')),
//         );
//         return;
//       }

//       // call CheckoutCubit to process payment (assumed implementation)
//       setState(() => _processing = true);
//       try {
//         final checkoutCubit = context.read<CheckoutCubit>();
//         checkoutCubit.selectPaymentMethod(_paymentMethod!);

//         if (_paymentMethod == 'card') {
//           // assume CheckoutCubit.processPayment handles Stripe backend (create payment intent etc)
//           await checkoutCubit.processPayment('card', total);
//         } else {
//           // COD: maybe skip processPayment and go straight to confirmation
//           // optionally notify cubit:
//           checkoutCubit.selectPaymentMethod('cod');
//         }
//         if (!mounted) return;
//         setState(() {
//           _processing = false;
//           _currentStep = 2;
//         });
//       } catch (e) {
//         setState(() => _processing = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Payment failed: $e')),
//         );
//       }
//       return;
//     }

//     if (_currentStep == 2) {
//       // confirm order: validate final state
//       if (_pickedAddress == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please provide a shipping address')),
//         );
//         return;
//       }
//       final cartState = context.read<CartCubit>().state;
//       if (cartState is! CartLoadedState || cartState.cartItems.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Cart is empty')),
//         );
//         return;
//       }

//       setState(() => _processing = true);
//   try {
//     // 1️⃣ Confirm order through CheckoutCubit
//     final checkoutCubit = context.read<CheckoutCubit>();
//     await checkoutCubit.confirmOrder(_pickedAddress!, _paymentMethod ?? 'cod');

//     // 2️⃣ Clear cart after confirming
//     context.read<CartCubit>().clearCart();

//     // 3️⃣ Navigate to OrderConfirmationScreen
//     if (!mounted) return;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) =>  OrderConfirmationScreen( ),
//       ),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Could not confirm order: $e')),
//     );
//   } finally {
//     if (mounted) setState(() => _processing = false);
//   }
// }
//   }

//   // Save address now (if user toggles save)
//   Future<void> _saveAddressNow(Addresses address, {String? userId}) async {
//     try {
//       await _addressRepo.saveAddress(address, userId: userId);
//       await _loadSavedAddresses();
//     } catch (e) {
//       debugPrint('Failed saving address: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed saving address: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _phoneController.dispose();
//     _streetController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _zipController.dispose();
//     _countryController.dispose();
//     super.dispose();
//   }

//   Widget _addressStepContent(String? userId) {
//     if (_loadingAddresses) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (_addressesError != null) {
//       return Center(child: Text('Error loading addresses: $_addressesError'));
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (_savedAddresses.isNotEmpty) ...[
//           const Text('Saved addresses',
//               style: TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           if (_savedAddresses.isNotEmpty)
//             DropdownButtonFormField<Addresses>(
//               decoration:
//                   const InputDecoration(labelText: 'Select Saved Address'),
//               value: _selectedSavedAddress,
//               items: _savedAddresses.map((addr) {
//                 return DropdownMenuItem(
//                   value: addr,
//                   child: Text(
//                     addr.displayString ?? 'No address details',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 );
//               }).toList(),
//               onChanged: (selected) {
//                 if (selected != null) {
//                   setState(() => _selectedSavedAddress = selected);
//                   _fullNameController.text = selected.fullName ?? '';
//                   _phoneController.text = selected.phone ?? '';
//                   _streetController.text = selected.street ?? '';
//                   _cityController.text = selected.city ?? '';
//                   _stateController.text = selected.state ?? '';
//                   _zipController.text = selected.zipCode ?? '';
//                   _countryController.text = selected.country ?? 'USA';
//                 }
//               },
//             ),
//           const Divider(),
//           const SizedBox(height: 8),
//         ],
//         Form(
//           key: _addressFormKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _fullNameController,
//                 decoration: const InputDecoration(labelText: 'Full name'),
//                 validator: (v) =>
//                     (v == null || v.trim().isEmpty) ? 'Required' : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(labelText: 'Phone'),
//                 keyboardType: TextInputType.phone,
//                 validator: (v) =>
//                     (v == null || v.trim().isEmpty) ? 'Required' : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _streetController,
//                 decoration: const InputDecoration(labelText: 'Street'),
//                 validator: (v) =>
//                     (v == null || v.trim().isEmpty) ? 'Required' : null,
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _cityController,
//                       decoration: const InputDecoration(labelText: 'City'),
//                       validator: (v) =>
//                           (v == null || v.trim().isEmpty) ? 'Required' : null,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: TextFormField(
//                       controller: _stateController,
//                       decoration:
//                           const InputDecoration(labelText: 'State (optional)'),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _zipController,
//                       decoration: const InputDecoration(labelText: 'Zip code'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: TextFormField(
//                       controller: _countryController,
//                       decoration: const InputDecoration(labelText: 'Country'),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.save),
//                     label: const Text('Save as new address'),
//                     onPressed: () {
//                       if (_addressFormKey.currentState!.validate()) {
//                         final addr = Addresses.create(
//                           fullName: _fullNameController.text,
//                           phone: _phoneController.text,
//                           street: _streetController.text,
//                           city: _cityController.text,
//                           state: _stateController.text,
//                           zipCode: _zipController.text,
//                           country: _countryController.text,
//                         );
//                         // try save; note: you may want to pass userId to sync to cloud
//                         _saveAddressNow(addr, userId: userId);
//                       }
//                     },
//                   ),
//                   const SizedBox(width: 12),
//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         _selectedSavedAddress = null;
//                         _pickedAddress = null;
//                         _fullNameController.clear();
//                         _phoneController.clear();
//                         _streetController.clear();
//                         _cityController.clear();
//                         _stateController.clear();
//                         _zipController.clear();
//                         _countryController.text = 'USA';
//                       });
//                     },
//                     child: const Text('Clear'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _paymentStepContent() {
//     return Column(
//       children: [
//         RadioListTile<String>(
//           title: const Text('Credit / Debit Card'),
//           value: 'card',
//           groupValue: _paymentMethod,
//           onChanged: (v) => setState(() => _paymentMethod = v),
//         ),
//         RadioListTile<String>(
//           title: const Text('Cash on Delivery'),
//           value: 'cod',
//           groupValue: _paymentMethod,
//           onChanged: (v) => setState(() => _paymentMethod = v),
//         ),
//         if (_paymentMethod == 'card') ...[
//           const SizedBox(height: 12),
//           // stripe CardField
//           CardField(
//             onCardChanged: (details) {
//               setState(() {
//                 _card = details;
//               });
//             },
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 12),
//           FutureBuilder<double>(
//             future: _computeTotal(),
//             builder: (context, snap) {
//               if (snap.connectionState == ConnectionState.waiting) {
//                 return const Text('Calculating total...');
//               }
//               final total = snap.data ?? 0.0;
//               return Text('Total to pay: \$${total.toStringAsFixed(2)}');
//             },
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _confirmationStepContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Order Summary',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         FutureBuilder<double>(
//           future: _computeTotal(),
//           builder: (context, snap) {
//             if (snap.connectionState == ConnectionState.waiting) {
//               return const Text('Calculating total...');
//             }
//             final total = snap.data ?? 0.0;
//             return Text('Total: \$${total.toStringAsFixed(2)}',
//                 style: const TextStyle(fontSize: 16));
//           },
//         ),
//         const SizedBox(height: 12),
//         const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         BlocBuilder<CartCubit, CartState>(
//           builder: (context, cartState) {
//             if (cartState is! CartLoadedState || cartState.cartItems.isEmpty) {
//               return const Text('No items in cart');
//             }
//             final items = cartState.cartItems;
//             return Column(
//               children: items.map((item) {
//                 final p = item['product'] as Product?;
//                 final qty = item['quantity'] ?? 1;
//                 if (p == null) return const SizedBox.shrink();
//                 return ListTile(
//                   leading: Image.network(p.image,
//                       width: 48,
//                       height: 48,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => const Icon(Icons.image)),
//                   title: Text(p.name),
//                   subtitle: Text('x$qty'),
//                   trailing: Text('\$${(p.price * qty).toStringAsFixed(2)}'),
//                 );
//               }).toList(),
//             );
//           },
//         ),
//         const SizedBox(height: 12),
//         const Text('Shipping to:',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 6),
//         Text(_pickedAddress?.displayString ?? 'No address selected'),
//         const SizedBox(height: 12),
//         Text('Payment: ${_paymentMethod?.toUpperCase() ?? 'Not selected'}'),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = context.watch<AuthCubit>().state;
//     final userId = authState is AuthSuccessState ? authState.user.uid : null;

//     return BlocProvider(
//       create: (_) => CheckoutCubit(userId: userId),
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Checkout')),
//         body: SafeArea(
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
//                   child: Stepper(
//                     physics: const NeverScrollableScrollPhysics(),
//                     currentStep: _currentStep,
//                     onStepTapped: (i) => setState(() => _currentStep = i),
//                     controlsBuilder: (_, details) =>
//                         const SizedBox.shrink(), // hide default controls
//                     steps: [
//                       Step(
//                         title: const Text('Shipping Address'),
//                         subtitle: Text(
//                             _pickedAddress?.city ?? 'Enter shipping address'),
//                         isActive: _currentStep == 0,
//                         state: _currentStep > 0
//                             ? StepState.complete
//                             : StepState.editing,
//                         content: _addressStepContent(userId),
//                       ),
//                       Step(
//                         title: const Text('Payment'),
//                         subtitle: Text(_paymentMethod == null
//                             ? 'Choose payment method'
//                             : _paymentMethod!.toUpperCase()),
//                         isActive: _currentStep == 1,
//                         state: _currentStep > 1
//                             ? StepState.complete
//                             : StepState.editing,
//                         content: _paymentStepContent(),
//                       ),
//                       Step(
//                         title: const Text('Confirmation'),
//                         isActive: _currentStep == 2,
//                         state: _currentStep > 2
//                             ? StepState.complete
//                             : StepState.editing,
//                         content: _confirmationStepContent(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Bottom fixed controls
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black.withOpacity(0.05), blurRadius: 8)
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     if (_currentStep > 0)
//                       TextButton(
//                         onPressed: () {
//                           if (_processing) return;
//                           setState(() => _currentStep--);
//                         },
//                         child: const Text('Back'),
//                       ),
//                     const Spacer(),
//                     ElevatedButton(
//                       onPressed: _processing ? null : _onStepContinue,
//                       child: _processing
//                           ? const SizedBox(
//                               width: 18,
//                               height: 18,
//                               child: CircularProgressIndicator(
//                                   strokeWidth: 2, color: Colors.white))
//                           : Text(
//                               _currentStep == 2 ? 'Confirm Order' : 'Continue'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/cart/cart_cubit.dart';
import 'package:lavaloon_ecommerce_app/features/auth/presentation/cubit/checkout/checkout_cubit.dart';
import '../../data/repositories/address_repository.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/product.dart';
import 'order_confirmation_screen.dart';  // Adjust path

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressRepo = AddressRepository();

  // Stepper state
  int _currentStep = 0;

  // Forms & controllers
  final _addressFormKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController(text: 'USA');

  // Addresses
  List<Addresses> _savedAddresses = [];
  Addresses? _selectedSavedAddress;
  Addresses? _pickedAddress; // final address used for order

  // Payment
  String? _paymentMethod; // 'card' or 'cod'
  CardFieldInputDetails? _card; // stripe card data

  // Loading / error
  bool _loadingAddresses = true;
  String? _addressesError;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  Future<void> _loadSavedAddresses() async {
    setState(() {
      _loadingAddresses = true;
      _addressesError = null;
    });
    try {
      final addresses = await _addressRepo.getSavedAddresses();
      // try to get default if exists
      final defaultAddr = await _addressRepo.getDefaultAddress();
      setState(() {
        _savedAddresses = addresses;
        if (defaultAddr.id.isNotEmpty) {
          _selectedSavedAddress = addresses.firstWhere(
            (a) => a.id == defaultAddr.id,
            orElse: () => defaultAddr,
          );
          _applySavedAddress(_selectedSavedAddress);
        }
        _loadingAddresses = false;
      });
    } catch (e) {
      setState(() {
        _addressesError = e.toString();
        _loadingAddresses = false;
      });
    }
  }

  void _applySavedAddress(Addresses? a) {
    if (a == null) return;
    _selectedSavedAddress = a;
    _pickedAddress = a;
    _fullNameController.text = a.fullName ?? '';
    _phoneController.text = a.phone ?? '';
    _streetController.text = a.street ?? '';
    _cityController.text = a.city ?? '';
    _stateController.text = a.state ?? '';
    _zipController.text = a.zipCode ?? '';
    _countryController.text = a.country ?? 'USA';
  }

  // Compute total via CartCubit — uses Future in case getTotal is async
  Future<double> _computeTotal() async {
    final cartCubit = context.read<CartCubit>();
    final totalMaybeFuture = cartCubit.getTotal(tax: 0.1);
    if (totalMaybeFuture is Future<double>) {
      return await totalMaybeFuture;
    } else if (totalMaybeFuture is double) {
      return totalMaybeFuture;
    } else {
      // fallback: try synchronous getter on repository or return 0
      return 0.0;
    }
  }

  // Shared continue handler (used by bottom button)
  Future<void> _onStepContinue() async {
    if (_processing) return;
    // ensure mounted after awaited ops
    if (_currentStep == 0) {
      // validate address form (if no saved address chosen)
      if (_selectedSavedAddress == null) {
        if (!_addressFormKey.currentState!.validate()) return;
        // build Addresses instance from controllers
        _pickedAddress = Addresses.create(
          fullName: _fullNameController.text,
          phone: _phoneController.text,
          street: _streetController.text,
          city: _cityController.text,
          state: _stateController.text,
          zipCode: _zipController.text,
          country: _countryController.text,
        );
      } else {
        // use selectedSavedAddress as picked
        _pickedAddress = _selectedSavedAddress;
      }

      // optionally save address if user checked (UI could include checkbox)
      // In this version we saved earlier via _saveAddressNow if needed
      // proceed
      setState(() => _currentStep = 1);
      return;
    }

    if (_currentStep == 1) {
      // require payment method
      if (_paymentMethod == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a payment method')),
        );
        return;
      }

      // if card payment, ensure card details are available
      if (_paymentMethod == 'card' && (_card == null || !_card!.complete)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter valid card details')),
        );
        return;
      }

      // compute total
      double total = 0.0;
      try {
        total = await _computeTotal();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error calculating total')),
        );
        return;
      }

      // call CheckoutCubit to process payment (assumed implementation)
      setState(() => _processing = true);
      try {
        final checkoutCubit = context.read<CheckoutCubit>();
        checkoutCubit.selectPaymentMethod(_paymentMethod!);

        if (_paymentMethod == 'card') {
          // assume CheckoutCubit.processPayment handles Stripe backend (create payment intent etc)
          await checkoutCubit.processPayment('card', total);
        } else {
          // COD: maybe skip processPayment and go straight to confirmation
          // optionally notify cubit:
          checkoutCubit.selectPaymentMethod('cod');
        }
        if (!mounted) return;
        setState(() {
          _processing = false;
          _currentStep = 2;
        });
      } catch (e) {
        setState(() => _processing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );
      }
      return;
    }

    if (_currentStep == 2) {
      // confirm order: validate final state
      if (_pickedAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please provide a shipping address')),
        );
        return;
      }
      final cartState = context.read<CartCubit>().state;
      if (cartState is! CartLoadedState || cartState.cartItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cart is empty')),
        );
        return;
      }

      setState(() => _processing = true);
      try {
        // FIXED: Call confirmOrder (emits CheckoutOrderConfirmed(order) on success)
        final checkoutCubit = context.read<CheckoutCubit>();
        await checkoutCubit.confirmOrder(_pickedAddress!, _paymentMethod ?? 'cod');

        // FIXED: Clear cart after confirm (move to listener if needed, but here for sync)
        context.read<CartCubit>().clearCart();

        // FIXED: Do NOT navigate here – Use BlocListener below to handle CheckoutOrderConfirmed and pass order
        // (Prevents race; listener reacts to emission)
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not confirm order: $e')),
        );
      } finally {
        if (mounted) setState(() => _processing = false);
      }
    }
  }

  // Save address now (if user toggles save)
  Future<void> _saveAddressNow(Addresses address, {String? userId}) async {
    try {
      await _addressRepo.saveAddress(address, userId: userId);
      await _loadSavedAddresses();
    } catch (e) {
      debugPrint('Failed saving address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed saving address: $e')),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Widget _addressStepContent(String? userId) {
    if (_loadingAddresses) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_addressesError != null) {
      return Center(child: Text('Error loading addresses: $_addressesError'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_savedAddresses.isNotEmpty) ...[
          const Text('Saved addresses',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (_savedAddresses.isNotEmpty)
            DropdownButtonFormField<Addresses>(
              decoration:
                  const InputDecoration(labelText: 'Select Saved Address'),
              value: _selectedSavedAddress,
              items: _savedAddresses.map((addr) {
                return DropdownMenuItem(
                  value: addr,
                  child: Text(
                    addr.displayString ?? 'No address details',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (selected) {
                if (selected != null) {
                  setState(() => _selectedSavedAddress = selected);
                  _fullNameController.text = selected.fullName ?? '';
                  _phoneController.text = selected.phone ?? '';
                  _streetController.text = selected.street ?? '';
                  _cityController.text = selected.city ?? '';
                  _stateController.text = selected.state ?? '';
                  _zipController.text = selected.zipCode ?? '';
                  _countryController.text = selected.country ?? 'USA';
                }
              },
            ),
          const Divider(),
          const SizedBox(height: 8),
        ],
        Form(
          key: _addressFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(labelText: 'Street'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration:
                          const InputDecoration(labelText: 'State (optional)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _zipController,
                      decoration: const InputDecoration(labelText: 'Zip code'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(labelText: 'Country'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save as new address'),
                    onPressed: () {
                      if (_addressFormKey.currentState!.validate()) {
                        final addr = Addresses.create(
                          fullName: _fullNameController.text,
                          phone: _phoneController.text,
                          street: _streetController.text,
                          city: _cityController.text,
                          state: _stateController.text,
                          zipCode: _zipController.text,
                          country: _countryController.text,
                        );
                        // try save; note: you may want to pass userId to sync to cloud
                        _saveAddressNow(addr, userId: userId);
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedSavedAddress = null;
                        _pickedAddress = null;
                        _fullNameController.clear();
                        _phoneController.clear();
                        _streetController.clear();
                        _cityController.clear();
                        _stateController.clear();
                        _zipController.clear();
                        _countryController.text = 'USA';
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentStepContent() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Credit / Debit Card'),
          value: 'card',
          groupValue: _paymentMethod,
          onChanged: (v) => setState(() => _paymentMethod = v),
        ),
        RadioListTile<String>(
          title: const Text('Cash on Delivery'),
          value: 'cod',
          groupValue: _paymentMethod,
          onChanged: (v) => setState(() => _paymentMethod = v),
        ),
        if (_paymentMethod == 'card') ...[
          const SizedBox(height: 12),
          // stripe CardField
          CardField(
            onCardChanged: (details) {
              setState(() {
                _card = details;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<double>(
            future: _computeTotal(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Text('Calculating total...');
              }
              final total = snap.data ?? 0.0;
              return Text('Total to pay: \$${total.toStringAsFixed(2)}');
            },
          ),
        ],
      ],
    );
  }

  Widget _confirmationStepContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        FutureBuilder<double>(
          future: _computeTotal(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Text('Calculating total...');
            }
            final total = snap.data ?? 0.0;
            return Text('Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16));
          },
        ),
        const SizedBox(height: 12),
        const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            if (cartState is! CartLoadedState || cartState.cartItems.isEmpty) {
              return const Text('No items in cart');
            }
            final items = cartState.cartItems;
            return Column(
              children: items.map((item) {
                final p = item['product'] as Product?;
                final qty = item['quantity'] ?? 1;
                if (p == null) return const SizedBox.shrink();
                return ListTile(
                  leading: Image.network(p.image,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image)),  // FIXED: Completed errorBuilder
                  title: Text(p.name),
                  subtitle: Text('x$qty'),
                  trailing: Text('\$${(p.price * qty).toStringAsFixed(2)}'),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 12),
        const Text('Shipping to:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(_pickedAddress?.displayString ?? 'No address selected'),
        const SizedBox(height:12),
        Text('Payment: ${_paymentMethod?.toUpperCase() ?? 'Not selected'}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final userId = authState is AuthSuccessState ? authState.user.uid : null;

    return BlocProvider(
      create: (_) => CheckoutCubit(userId: userId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Stepper(
                    physics: const NeverScrollableScrollPhysics(),
                    currentStep: _currentStep,
                    onStepTapped: (i) => setState(() => _currentStep = i),
                    controlsBuilder: (_, details) =>
                        const SizedBox.shrink(), // hide default controls
                    steps: [
                      Step(
                        title: const Text('Shipping Address'),
                        subtitle: Text(
                            _pickedAddress?.city ?? 'Enter shipping address'),
                        isActive: _currentStep == 0,
                        state: _currentStep > 0
                            ? StepState.complete
                            : StepState.editing,
                        content: _addressStepContent(userId),
                      ),
                      Step(
                        title: const Text('Payment'),
                        subtitle: Text(_paymentMethod == null
                            ? 'Choose payment method'
                            : _paymentMethod!.toUpperCase()),
                        isActive: _currentStep == 1,
                        state: _currentStep > 1
                            ? StepState.complete
                            : StepState.editing,
                        content: _paymentStepContent(),
                      ),
                      Step(
                        title: const Text('Confirmation'),
                        isActive: _currentStep == 2,
                        state: _currentStep > 2
                            ? StepState.complete
                            : StepState.editing,
                        content: _confirmationStepContent(),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom fixed controls
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 8)
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: () {
                          if (_processing) return;
                          setState(() => _currentStep--);
                        },
                        child: const Text('Back'),
                      ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _processing ? null : _onStepContinue,
                      child: _processing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Text(
                              _currentStep == 2 ? 'Confirm Order' : 'Continue'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
