import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/features/AvailableSizeProduct/availableSizeProduct_page.dart';
import 'package:flutter_ltdddoan/model/available_product_sizes.dart';

class AvailableSizeProductsPage extends StatelessWidget {
  const AvailableSizeProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Size Products'),
      ),
      // body: ListView.builder(
      //   itemCount: availableSizeProducts.length,
      //   itemBuilder: (context, index) {
      //     final sizeProduct = availableSizeProducts[index];
      //     return ListTile(
      //       title: Text('Product ID: ${sizeProduct.productId}'),
      //       subtitle: Text('Size Product ID: ${sizeProduct.sizeProductId}'),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => AvailableSizeProductPage(
      //               availableSizeProduct: sizeProduct,
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
