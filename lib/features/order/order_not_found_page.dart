import 'package:flutter/material.dart';

class OrderNotFoundPage extends StatelessWidget {
  const OrderNotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Not Found'),
      ),
      body: Center(
        child: Text('Order Not Found'),
      ),
    );
  }
}
