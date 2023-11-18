import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class Donate extends StatefulWidget {
  const Donate({super.key});

  @override
  State<Donate> createState() => _DonateState();
}

class _DonateState extends State<Donate> {

  late final PaymentConfiguration _googlePayConfigFuture;

  @override
  void initState() {
    super.initState();
  }

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Donate'),
    );
  }
}