import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/features/GenderCategory/genderCategory_page.dart';
import 'package:flutter_ltdddoan/model/gendercategory_model.dart';

class GenderCategoriesPage extends StatelessWidget {
  const GenderCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gender Categories'),
      ),
      // body: ListView.builder(
      //   itemCount: genderCategories.length,
      //   itemBuilder: (context, index) {
      //     final category = genderCategories[index];
      //     return ListTile(
      //       title: Text(category.name),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => GenderCategoryPage(
      //               genderCategory: category,
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
