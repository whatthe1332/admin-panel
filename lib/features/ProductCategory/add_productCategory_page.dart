import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/productcategory_model.dart';
import 'package:flutter_ltdddoan/repositories/productCategory/productCategory_repository.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class AddProductCategoryPage extends StatefulWidget {
  const AddProductCategoryPage({Key? key}) : super(key: key);

  @override
  _AddProductCategoryPageState createState() => _AddProductCategoryPageState();
}

class _AddProductCategoryPageState extends State<AddProductCategoryPage> {
  late final TextEditingController _nameController;
  late bool _isActive;
  late final ProductCategoryRepository _productCategoryRepository;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _isActive = true; // Set isActive to true by default for new category
    _productCategoryRepository = ProductCategoryRepository();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentView(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Text('Is Active:'),
                Checkbox(
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value!;
                    });
                  },
                ),
              ],
            ),
            const Gap(16),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm'),
                  onPressed: _addProductCategory,
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.navigate_before),
                  label: const Text('Quay lại'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addProductCategory() async {
    final newProductCategory = ProductCategory(
      productCategoryId: '',
      name: _nameController.text,
      isActive: _isActive,
      createdBy: 'admin',
      createDate: DateTime.now(),
      updatedDate: DateTime.now(),
      updatedBy: 'admin',
    );

    try {
      await _productCategoryRepository.addProductCategory(newProductCategory);
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error adding product category: $e');
    }
  }
}
