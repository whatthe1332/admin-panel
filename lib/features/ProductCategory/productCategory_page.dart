import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/productcategory_model.dart';
import 'package:flutter_ltdddoan/repositories/productCategory/productCategory_repository.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class ProductCategoryPage extends StatefulWidget {
  const ProductCategoryPage({Key? key, required this.productCategory})
      : super(key: key);

  final ProductCategory productCategory;

  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  late final TextEditingController _nameController;
  late bool _isActive;
  late final ProductCategoryRepository _productCategoryRepository;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productCategory.name);
    _isActive = widget.productCategory.isActive;
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
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu'),
                  onPressed: _saveProductCategory,
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

  Future<void> _saveProductCategory() async {
    final updatedProductCategory = ProductCategory(
      productCategoryId: widget.productCategory.productCategoryId,
      name: _nameController.text,
      isActive: _isActive,
      createdBy: widget.productCategory.createdBy,
      createDate: widget.productCategory.createDate,
      updatedDate: DateTime.now(),
      updatedBy: widget.productCategory.updatedBy,
    );

    try {
      await _productCategoryRepository
          .editProductCategory(updatedProductCategory);
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error saving product category: $e');
    }
  }
}
