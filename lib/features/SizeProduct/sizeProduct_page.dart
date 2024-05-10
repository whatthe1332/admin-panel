import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/sizeproduct_model.dart';
import 'package:flutter_ltdddoan/repositories/sizeProduct/sizeProduct_repository.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class SizeProductPage extends StatefulWidget {
  const SizeProductPage({Key? key, required this.sizeProduct})
      : super(key: key);

  final SizeProduct sizeProduct;

  @override
  _SizeProductPageState createState() => _SizeProductPageState();
}

class _SizeProductPageState extends State<SizeProductPage> {
  late final TextEditingController _nameController;
  late bool _isActive;
  late final SizeProductRepository _sizeProductRepository;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sizeProduct.name);
    _isActive = widget.sizeProduct.isActive;
    _sizeProductRepository = SizeProductRepository();
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
                  onPressed: _saveSizeProduct,
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

  Future<void> _saveSizeProduct() async {
    final updatedSizeProduct = SizeProduct(
      sizeProductId: widget.sizeProduct.sizeProductId,
      name: _nameController.text,
      isActive: _isActive,
      createdBy: widget.sizeProduct.createdBy,
      createDate: widget.sizeProduct.createDate,
      updatedDate: DateTime.now(),
      updatedBy: widget.sizeProduct.updatedBy,
    );

    try {
      await _sizeProductRepository.editSizeProduct(updatedSizeProduct);
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error saving size product: $e');
    }
  }
}
