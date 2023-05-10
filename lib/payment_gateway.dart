import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:payment_gateway/api_key.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Razorpay _razorpay;
  @override
  void initState() {
    _razorpay = Razorpay();
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "SUCCESS: " + response.paymentId!,
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "SUCCESS: " + response.code.toString() + " - " + response.message!,
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "EXTERNAL_WALLET: " + response.walletName!,
        ),
      ),
    );
  }

  void openCheckout() async {
    var options = {
      'key': apiKey,
      'amount':
          (double.parse(_controller.text) * 100.roundToDouble()).toString(),
      'name': 'Sufiyan',
      'description': 'Bonus',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      log(e.toString());
    }
  }

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: 5,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  openCheckout();
                },
                child: const Text(
                  "Pay Now",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
