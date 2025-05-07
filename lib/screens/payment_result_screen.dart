import 'package:flutter/material.dart';

import '../utils/strings.dart';
import '../widgets/primary_button.dart';
import 'navigation_bar_screen.dart';

class PaymentResultScreen extends StatefulWidget {
  final bool isSuccess;
  final Map<dynamic, dynamic> data;

  const PaymentResultScreen({
    super.key,
    required this.isSuccess,
    required this.data,
  });

  @override
  State<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: widget.isSuccess ? Colors.green : Colors.red,
        title: Text(
          widget.isSuccess ? 'Payment Successful' : 'Payment Failed',
          style: TextStyle(color: colorScheme.secondary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: widget.isSuccess ? _buildSuccessView() : _buildErrorView(),
      ),
    );
  }

  Widget _buildSuccessView() {
    final message = widget.data['message'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 20,
      children: [
        Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
        Text(
          AppStrings.thankforpayment,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text("Payment ID: ${message['id']}", style: _textStyle()),
        Text(
          "Amount Received: PKR ${(message['amount_received'] / 100).toStringAsFixed(2)}",
          style: _textStyle(),
        ),
        Text(
          "Currency: ${message['currency']?.toUpperCase()}",
          style: _textStyle(),
        ),
        Text("Status: ${message['status']}", style: _textStyle()),
        const SizedBox(height: 20),
        PrimaryButton(
          text: "Back to Home",
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NavigationBarScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red, size: 80),
          const SizedBox(height: 20),
          Text("Error Type: ${widget.data['exc_type']}", style: _textStyle()),
          Text("Message: ${widget.data['exception']}", style: _textStyle()),
          const SizedBox(height: 20),
          const Text(
            "Please try again or contact support.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle() =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
}
