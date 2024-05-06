import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/sizeproduct_model.dart';

class SizeProductPage extends StatelessWidget {
  final SizeProduct sizeProduct;

  const SizeProductPage({Key? key, required this.sizeProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Size Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Size Product ID: ${sizeProduct.sizeProductId}'),
            Text('Name: ${sizeProduct.name}'),
            Text('Is Active: ${sizeProduct.isActive}'),
            Text('Created By: ${sizeProduct.createdBy}'),
            Text('Create Date: ${sizeProduct.createDate}'),
            Text('Updated Date: ${sizeProduct.updatedDate}'),
            Text('Updated By: ${sizeProduct.updatedBy}'),
          ],
        ),
      ),
    );
  }
}
