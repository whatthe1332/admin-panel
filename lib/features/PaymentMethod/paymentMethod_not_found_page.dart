import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PaymentMethodNotFoundPage extends StatelessWidget {
  const PaymentMethodNotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method Not Found'),
      ),
      body: Center(
        child: Text('Payment Method Not Found'),
      ),
    );
  }
}
