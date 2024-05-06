import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/features/ProductCategory/productCategory_page.dart';
import 'package:flutter_ltdddoan/model/productcategory_model.dart';

class ProductCategoriesPage extends StatelessWidget {
  const ProductCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Categories'),
      ),
      // body: ListView.builder(
      //   itemCount: productCategories.length,
      //   itemBuilder: (context, index) {
      //     final category = productCategories[index];
      //     return ListTile(
      //       title: Text(category.name),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => ProductCategoryPage(
      //               productCategory: category,
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
