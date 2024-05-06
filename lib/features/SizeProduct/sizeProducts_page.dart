import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/features/SizeProduct/sizeProduct_page.dart';
import 'package:flutter_ltdddoan/model/sizeproduct_model.dart';

class SizeProductsPage extends StatelessWidget {
  const SizeProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Size Products'),
      ),
      // body: ListView.builder(
      //   itemCount: sizeProducts.length,
      //   itemBuilder: (context, index) {
      //     final sizeProduct = sizeProducts[index];
      //     return ListTile(
      //       title: Text('Size Product ID: ${sizeProduct.sizeProductId}'),
      //       subtitle: Text('Name: ${sizeProduct.name}'),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => SizeProductPage(
      //               sizeProduct: sizeProduct,
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
