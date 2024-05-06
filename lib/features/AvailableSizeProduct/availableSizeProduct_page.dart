import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/available_product_sizes.dart';

class AvailableSizeProductPage extends StatelessWidget {
  final AvailableSizeProduct availableSizeProduct;

  const AvailableSizeProductPage({Key? key, required this.availableSizeProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Size Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ID: ${availableSizeProduct.id}'),
            Text('Product ID: ${availableSizeProduct.productId}'),
            Text('Size Product ID: ${availableSizeProduct.sizeProductId}'),
            Text('Quantity: ${availableSizeProduct.quantity}'),
          ],
        ),
      ),
    );
  }
}
