import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/available_product_sizes.dart';
import 'package:flutter_ltdddoan/repositories/availableProduct/availableProduct_repository.dart';

class AvailableSizeProductPage extends StatefulWidget {
  const AvailableSizeProductPage({Key? key, required this.availableSizeProduct})
      : super(key: key);

  final AvailableSizeProduct availableSizeProduct;

  @override
  _AvailableSizeProductPageState createState() =>
      _AvailableSizeProductPageState();
}

class _AvailableSizeProductPageState extends State<AvailableSizeProductPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<DropdownMenuItem<String>> _productItems;
  late List<DropdownMenuItem<String>> _sizeProductItems;
  late TextEditingController _quantityController;
  late final AvailableSizeProductRepository availableSizeProductRepository =
      AvailableSizeProductRepository();
  String? _selectedProductId;
  String? _selectedSizeProductId;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _loadProducts();
    _loadSizeProducts();
    _initializeFields();
  }

  void _initializeFields() {
    // Load data from availableSizeProduct when the page is opened
    _selectedProductId = widget.availableSizeProduct.productId;
    _selectedSizeProductId = widget.availableSizeProduct.sizeProductId;
    _quantityController.text = widget.availableSizeProduct.quantity.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final QuerySnapshot productSnapshot =
        await _firestore.collection('products').get();
    setState(() {
      _productItems = productSnapshot.docs.map((DocumentSnapshot document) {
        return DropdownMenuItem<String>(
          value: document.id,
          child: Text(document['name']),
        );
      }).toList();
    });
  }

  Future<void> _loadSizeProducts() async {
    final QuerySnapshot sizeProductSnapshot =
        await _firestore.collection('sizeproduct').get();
    setState(() {
      _sizeProductItems =
          sizeProductSnapshot.docs.map((DocumentSnapshot document) {
        return DropdownMenuItem<String>(
          value: document.id,
          child: Text(document['name']),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Product'),
              value: _selectedProductId,
              items: _productItems,
              onChanged: (value) {
                setState(() {
                  _selectedProductId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Size Product'),
              value: _selectedSizeProductId,
              items: _sizeProductItems,
              onChanged: (value) {
                setState(() {
                  _selectedSizeProductId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu'),
                  onPressed: _saveAvailableSizeProduct,
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

  Future<void> _saveAvailableSizeProduct() async {
    if (_selectedProductId != null &&
        _selectedSizeProductId != null &&
        _quantityController.text.isNotEmpty) {
      final updatedAvailableSizeProduct = AvailableSizeProduct(
        productId: _selectedProductId!,
        sizeProductId: _selectedSizeProductId!,
        quantity: int.parse(_quantityController.text),
        availableSizeProductId:
            widget.availableSizeProduct.availableSizeProductId,
      );
      try {
        await availableSizeProductRepository
            .editAvailableSizeProduct(updatedAvailableSizeProduct);
        Navigator.of(context).pop(true);
      } catch (e) {
        print('Error saving available size product: $e');
      }
    } else {
      // Display a warning if any data is missing
      print('Please select product, size product, and enter quantity.');
    }
  }
}
