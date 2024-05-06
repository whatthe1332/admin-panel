import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/gendercategory_model.dart';

class GenderCategoryPage extends StatelessWidget {
  final GenderCategory genderCategory;

  const GenderCategoryPage({Key? key, required this.genderCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gender Category Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gender Category ID: ${genderCategory.genderCategoryId}'),
            Text('Name: ${genderCategory.name}'),
            Text('Is Active: ${genderCategory.isActive}'),
            Text('Created By: ${genderCategory.createdBy}'),
            Text('Created Date: ${genderCategory.createDate}'),
            Text('Updated Date: ${genderCategory.updatedDate}'),
            Text('Updated By: ${genderCategory.updatedBy}'),
          ],
        ),
      ),
    );
  }
}
