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

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _priceSaleController =
        TextEditingController(text: widget.product.priceSale.toString());
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    _isNew = widget.product.isNew;
    _isSale = widget.product.isSale;
    _isHot = widget.product.isHot;
    _isSoldOut = widget.product.isSoldOut;
    _isActive = widget.product.isActive;
    _loadImageUrls();
    _fetchProductCategories();
    _fetchGenderCategories();
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

  Future<void> _fetchProductCategories() async {
    try {
      List<ProductCategory> categories =
          await productCategoryRepository.getAllProductCategories();
      setState(() {
        _productCategories = categories;
        _selectedProductCategory = categories.firstWhere(
          (category) =>
              category.productCategoryId == widget.product.productCategoryId,
          orElse: () => ProductCategory(
            productCategoryId: '',
            name: 'Unknown',
            isActive: false,
            createdBy: '',
            createDate: DateTime.now(),
            updatedDate: DateTime.now(),
            updatedBy: '',
          ),
        );
      });
    } catch (e) {
      print('Error fetching product categories: $e');
    }
  }

  Future<void> _fetchGenderCategories() async {
    try {
      List<GenderCategory> categories =
          await genderCategoryRepository.getAllGenderCategories();
      setState(() {
        _genderCategories = categories;
        // Tìm kiếm danh mục giới tính có genderCategoryId trùng với widget.product.genderCategoryId
        _selectedGenderCategory = categories.firstWhere(
          (category) =>
              category.genderCategoryId == widget.product.genderCategoryId,
          orElse: () => GenderCategory(
            genderCategoryId: '',
            name: 'Unknown',
            isActive: false,
            createdBy: '',
            createDate: DateTime.now(),
            updatedDate: DateTime.now(),
            updatedBy: '',
          ),
        );
      });
    } catch (e) {
      print('Error fetching gender categories: $e');
    }
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
              value:
                  _selectedProductCategory, // Đặt giá trị ban đầu cho DropdownButtonFormField
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
                Text('Rating: ${widget.product.rating}/5'),
                Icon(Icons.star, color: Colors.yellow),
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

  Future<void> _loadImageUrls() async {
    try {
      String documentId = widget.product.productId;
      List<String> imageUrls = await productRepository.getImageUrls(documentId);
      setState(() {
        _tempImagePaths = imageUrls;
      });
    } catch (e) {
      print('Error loading image URLs: $e');
    }
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
        final imageName = 'image_$index.png';
        productRepository.deleteImageUrl(widget.product.productId, imageName);
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
    // Sử dụng danh sách _tempImagePaths để tạo danh sách URL hình ảnh mới
    List<String> updatedImageUrls = [
      ...widget.product.imageUrls,
      ..._tempImagePaths
    ];

    final updatedProduct = Product(
      productId: widget.product.productId,
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
      createdBy: widget.product.createdBy,
      createDate: widget.product.createDate,
      updatedDate: DateTime.now(),
      rating: widget.product.rating,
      sizeProductId: widget.product.sizeProductId,
      genderCategoryId: _selectedGenderCategory?.genderCategoryId ?? '',
      productCategoryId: _selectedProductCategory?.productCategoryId ?? '',
      discountId: widget.product.discountId,
      imageUrls: updatedImageUrls,
    );

    try {
      await productRepository.updatedProduct(updatedProduct);
      await productRepository.uploadImageUrls(
        widget.product.productId,
        _tempImagePaths,
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error saving product: $e');
    }
  }

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
}
