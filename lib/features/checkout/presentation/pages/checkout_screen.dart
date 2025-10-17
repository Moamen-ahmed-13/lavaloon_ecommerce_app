import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavaloon_ecommerce_app/features/checkout/presentation/widgets/address_step.dart';
import 'package:lavaloon_ecommerce_app/features/checkout/presentation/widgets/order_confirmation.dart';
import 'package:lavaloon_ecommerce_app/features/checkout/presentation/widgets/payment_step.dart';
import '../cubit/checkout_cubit.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CheckoutCubit>().startCheckout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CheckoutProcessing) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing your order...'),
                ],
              ),
            );
          }
          
          if (state is CheckoutAddressStep) {
            return AddressStepWidget(savedAddress: state.savedAddress);
          }
          
          if (state is CheckoutPaymentStep) {
            return PaymentStepWidget(
              address: state.address,
              selectedPaymentMethod: state.selectedPaymentMethod,
            );
          }
          
          if (state is CheckoutSuccess) {
            return OrderConfirmationWidget(order: state.order);
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}