import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/available_product_sizes.dart';
import 'package:flutter_ltdddoan/repositories/availableProduct/availableProduct_repository.dart';

class AddAvailableSizeProductPage extends StatefulWidget {
  @override
  _AddAvailableSizeProductPageState createState() =>
      _AddAvailableSizeProductPageState();
}

class _AddAvailableSizeProductPageState
    extends State<AddAvailableSizeProductPage> {
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
            ElevatedButton(
              onPressed: _saveAvailableSizeProduct,
              child: Text('Save'),
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
      final newAvailableSizeProduct = AvailableSizeProduct(
        productId: _selectedProductId!,
        sizeProductId: _selectedSizeProductId!,
        quantity: int.parse(_quantityController.text),
        availableSizeProductId: '',
      );
      try {
        await availableSizeProductRepository
            .addAvailableSizeProduct(newAvailableSizeProduct);
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
