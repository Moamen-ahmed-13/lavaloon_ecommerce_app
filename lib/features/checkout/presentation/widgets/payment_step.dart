import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavaloon_ecommerce_app/features/orders/domain/entities/order_entity.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/address_entity.dart';
import '../cubit/checkout_cubit.dart';

class PaymentStepWidget extends StatelessWidget {
  final AddressEntity address;
  final PaymentMethod selectedPaymentMethod;

  const PaymentStepWidget({
    Key? key,
    required this.address,
    required this.selectedPaymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Indicator
          const Text(
            'Step 2 of 3',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Delivery Address Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<CheckoutCubit>().backToAddress();
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(address.fullName),
                  Text(address.phone),
                  Text(address.street),
                  Text('${address.city}, ${address.state} ${address.zipCode}'),
                  Text(address.country),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Payment Methods
          const Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Credit Card Option
          RadioListTile<PaymentMethod>(
            value: PaymentMethod.creditCard,
            groupValue: selectedPaymentMethod,
            onChanged: (value) {
              if (value != null) {
                context.read<CheckoutCubit>().selectPaymentMethod(value);
              }
            },
            title: const Row(
              children: [
                Icon(Icons.credit_card, color: Colors.blue),
                SizedBox(width: 12),
                Text('Credit/Debit Card'),
              ],
            ),
            subtitle: const Text('Pay securely with Stripe'),
          ),

          // Cash on Delivery Option
          RadioListTile<PaymentMethod>(
            value: PaymentMethod.cashOnDelivery,
            groupValue: selectedPaymentMethod,
            onChanged: (value) {
              if (value != null) {
                context.read<CheckoutCubit>().selectPaymentMethod(value);
              }
            },
            title: const Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.green),
                SizedBox(width: 12),
                Text('Cash on Delivery'),
              ],
            ),
            subtitle: const Text('Pay when you receive the order'),
          ),

          const SizedBox(height: 24),

          // Order Summary
          BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SummaryRow(
                        label: 'Items (${cartState.itemCount})',
                        value: '\$${cartState.subtotal.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Tax',
                        value: '\$${cartState.tax.toStringAsFixed(2)}',
                      ),
                      const Divider(height: 24),
                      _SummaryRow(
                        label: 'Total',
                        value: '\$${cartState.total.toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Place Order Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<CheckoutCubit>().processPayment();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                selectedPaymentMethod == PaymentMethod.creditCard
                    ? 'Pay Now'
                    : 'Place Order',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
