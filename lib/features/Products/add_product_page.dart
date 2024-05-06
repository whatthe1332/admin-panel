import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/gendercategory_model.dart';
import 'package:flutter_ltdddoan/model/product_model.dart';
import 'package:flutter_ltdddoan/model/productcategory_model.dart';
import 'package:flutter_ltdddoan/repositories/genderCategory/genderCategory_repository.dart';
import 'package:flutter_ltdddoan/repositories/productCategory/productCategory_repository.dart';
import 'package:flutter_ltdddoan/repositories/products/product_detail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  ProductRepository productRepository = ProductRepository();
  ProductCategoryRepository productCategoryRepository =
      ProductCategoryRepository();
  GenderCategoryRepository genderCategoryRepository =
      GenderCategoryRepository();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _priceSaleController;
  late TextEditingController _quantityController;
  List<String> _tempImagePaths = [];
  bool _isNew = false;
  bool _isSale = false;
  bool _isHot = false;
  bool _isSoldOut = false;
  bool _isActive = false;
  int? _hoveredImageIndex;
  List<ProductCategory> _productCategories = [];
  ProductCategory? _selectedProductCategory;
  List<GenderCategory> _genderCategories = [];
  GenderCategory? _selectedGenderCategory;

  void _startHover(int index) {
    setState(() {
      _hoveredImageIndex = index;
    });
  }

  void _stopHover() {
    setState(() {
      _hoveredImageIndex = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _priceSaleController = TextEditingController();
    _quantityController = TextEditingController();
    _fetchProductCategories();
    _fetchGenderCategories();
  }

  Future<void> _fetchProductCategories() async {
    try {
      List<ProductCategory> categories =
          await productCategoryRepository.getAllProductCategories();
      setState(() {
        _productCategories = categories;
        _selectedProductCategory =
            categories.isNotEmpty ? categories.first : null;
      });
    } catch (e) {
      print('Error fetching gender categories: $e');
    }
  }

  Future<void> _fetchGenderCategories() async {
    try {
      List<GenderCategory> categories =
          await genderCategoryRepository.getAllGenderCategories();
      setState(() {
        _genderCategories = categories;
        _selectedGenderCategory =
            categories.isNotEmpty ? categories.first : null;
      });
    } catch (e) {
      print('Error fetching gender categories: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _priceSaleController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentView(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Images: '),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _tempImagePaths.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final String path = entry.value;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MouseRegion(
                            // Khi người dùng rê vào hình ảnh
                            onEnter: (_) => _startHover(index),
                            // Khi người dùng dừng rê vào hình ảnh
                            onExit: (_) => _stopHover(),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Xử lý khi người dùng nhấn vào hình ảnh
                                  },
                                  child: Image.network(
                                    path,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Nút xóa chỉ hiển thị khi chỉ số của hình ảnh khớp với hình ảnh được rê vào
                                if (_hoveredImageIndex == index)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteImage(index),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _pickImage,
                ),
              ],
            ),
            const Gap(16),
            const Gap(16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            TextField(
              controller: _priceSaleController,
              decoration: InputDecoration(
                labelText: 'Price Sale',
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            DropdownButtonFormField<ProductCategory>(
              decoration: InputDecoration(
                labelText: 'Product Category',
                border: OutlineInputBorder(),
              ),
              value: _selectedProductCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedProductCategory = newValue;
                });
              },
              items: _productCategories.map((category) {
                return DropdownMenuItem<ProductCategory>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
            ),
            const Gap(16),
            DropdownButtonFormField<GenderCategory>(
              decoration: InputDecoration(
                labelText: 'Gender Category',
                border: OutlineInputBorder(),
              ),
              value: _selectedGenderCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedGenderCategory = newValue;
                });
              },
              items: _genderCategories.map((category) {
                return DropdownMenuItem<GenderCategory>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
            ),
            const Gap(16),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Text('Is New:'),
                Checkbox(
                  value: _isNew,
                  onChanged: (value) {
                    setState(() {
                      _isNew = value!;
                    });
                  },
                ),
                const Gap(8),
                Text('Is Sale:'),
                Checkbox(
                  value: _isSale,
                  onChanged: (value) {
                    setState(() {
                      _isSale = value!;
                    });
                  },
                ),
                const Gap(8),
                Text('Is Hot:'),
                Checkbox(
                  value: _isHot,
                  onChanged: (value) {
                    setState(() {
                      _isHot = value!;
                    });
                  },
                ),
                const Gap(8),
                Text('Is Sold Out:'),
                Checkbox(
                  value: _isSoldOut,
                  onChanged: (value) {
                    setState(() {
                      _isSoldOut = value!;
                    });
                  },
                ),
              ],
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
                  label: const Text('Save'),
                  onPressed: _saveProduct,
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.navigate_before),
                  label: const Text('Back'),
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

  Future<bool?> _confirmDeleteImage() async {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa!'),
          content: Text('Bạn có chắc muốn xóa hình ảnh này chứ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Có'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Không'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _tempImagePaths
            .add(pickedImage.path); // Thêm đường dẫn hình ảnh mới vào danh sách
      });
    }
  }

  void _deleteImage(int index) async {
    final confirmed = await _confirmDeleteImage();
    if (confirmed != null && confirmed) {
      try {
        final imageName = 'image_$index';
        setState(() {
          _tempImagePaths.removeAt(index);
          _hoveredImageIndex = null;
        });
      } catch (e) {
        print('Error deleting image: $e');
      }
    }
  }

  void _saveProduct() async {
    List<String> updatedImageUrls = [..._tempImagePaths];

    final NewProduct = Product(
      productId: '',
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      priceSale: double.parse(_priceSaleController.text),
      quantity: int.parse(_quantityController.text),
      isNew: _isNew,
      isSale: _isSale,
      isHot: _isHot,
      isSoldOut: _isSoldOut,
      isActive: _isActive,
      createdBy: 'admin',
      createDate: DateTime.now(),
      updatedDate: DateTime.now(),
      rating: 0,
      sizeProductId: '', // Sau này sửa chỗ này
      genderCategoryId: _selectedGenderCategory?.genderCategoryId ?? '',
      productCategoryId: _selectedProductCategory?.productCategoryId ?? '',
      discountId: '', // Sau này sửa chỗ này
      imageUrls: updatedImageUrls,
    );

    try {
      await productRepository.addProduct(NewProduct, updatedImageUrls);
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error add product: $e');
    }
  }
}
