import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/productcategory_model.dart';

class ProductCategoryPage extends StatelessWidget {
  final ProductCategory productCategory;

  const ProductCategoryPage({Key? key, required this.productCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Category Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category ID: ${productCategory.productCategoryId}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Name: ${productCategory.name}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Active: ${productCategory.isActive ? 'Yes' : 'No'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Created By: ${productCategory.createdBy}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Create Date: ${productCategory.createDate}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Updated Date: ${productCategory.updatedDate}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Updated By: ${productCategory.updatedBy}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
