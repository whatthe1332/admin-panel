import 'package:flutter/material.dart';

class DiscountNotFoundPage extends StatelessWidget {
  const DiscountNotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discount Not Found'),
      ),
      body: Center(
        child: Text('Discount Not Found'),
      ),
    );
  }
}
