import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  final Dio dio;
  // Replace with your actual backend URL

  static const String backendUrl = 'https://api.stripe.com/v1';
  StripeService({required this.dio});

  Future<bool> makePayment(double amount) async {
    try {
      // Step 1: Create payment intent on your backend
      final paymentIntent = await _createPaymentIntent(amount);

      // Step 2: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          style: ThemeMode.light,
        ),
      );

      // Step 3: Display Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      print('Error making payment: $e');
      return false;
    }
  }

  Future<Map<dynamic, dynamic>> _createPaymentIntent(double amount) async {
    try {
      final response = await dio.post(
        // In a real app, call your backend to create payment intent
        // For demo purposes, we'll return a mock response
        // YOU NEED TO IMPLEMENT YOUR BACKEND API HERE
        '$backendUrl/payment_intents',
        data: {
          'amount': (amount * 100).toInt(), // Stripe uses cents
          'currency': 'USD',
        },
      );
      return response.data;
    } on Exception catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }
}
