import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/discount_model.dart';
import 'package:flutter_ltdddoan/repositories/discount/discount_repository.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/widgets.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({Key? key, required this.discount}) : super(key: key);

  final Discount discount;

  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  DiscountRepository discountRepository = DiscountRepository();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  bool _isActive = false;
  String _tempImagePath = '';
  int? _hoveredImageIndex;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.discount.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.discount.description ?? '');
    _valueController =
        TextEditingController(text: widget.discount.value?.toString() ?? '');
    _quantityController =
        TextEditingController(text: widget.discount.quantity?.toString() ?? '');
    _priceController =
        TextEditingController(text: widget.discount.price?.toString() ?? '');
    _isActive = widget.discount.isActive ?? false;
    _loadImageUrls();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  Future<void> _loadImageUrls() async {
    try {
      String documentId = widget.discount.discountId!;
      List<String> imageUrls =
          await discountRepository.getImageUrls(documentId);
      setState(() {
        _tempImagePath = imageUrls.first;
      });
    } catch (e) {
      print('Error loading image URLs: $e');
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
                      children: _tempImagePath.isNotEmpty
                          ? _buildImageWidgets()
                          : [Text('No images')],
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
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
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
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
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
                      _isActive = value ?? false;
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
                  onPressed: _saveDiscount,
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

  List<Widget> _buildImageWidgets() {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: MouseRegion(
          onEnter: (_) => _startHover(0),
          onExit: (_) => _stopHover(),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  // Handle image tap
                },
                child: Image.network(
                  _tempImagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              if (_hoveredImageIndex == 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteImage(0),
                  ),
                ),
            ],
          ),
        ),
      ),
    ];
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _tempImagePath = pickedImage.path;
      });
    }
  }

  void _deleteImage(int index) async {
    final confirmed = await _confirmDeleteImage();
    if (confirmed != null && confirmed) {
      try {
        final imageName = 'image_$index.png';
        discountRepository.deleteImageUrl(
            widget.discount.discountId!, imageName);
        setState(() {
          _tempImagePath = '';
          _hoveredImageIndex = null;
        });
      } catch (e) {
        print('Error deleting image: $e');
      }
    }
  }

  Future<bool?> _confirmDeleteImage() async {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete!'),
          content: Text('Are you sure you want to delete this image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _saveDiscount() async {
    final updatedDiscount = Discount(
      discountId: widget.discount.discountId,
      name: _nameController.text,
      isActive: _isActive,
      createdBy: widget.discount.createdBy,
      createDate: widget.discount.createDate,
      updatedDate: DateTime.now(),
      updatedBy: widget.discount.updatedBy,
      description: _descriptionController.text,
      value: widget.discount.value,
      quantity: widget.discount.quantity,
      price: widget.discount.price,
      image: widget.discount.image,
    );

    try {
      await discountRepository.updateDiscount(updatedDiscount, _tempImagePath);
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error saving discount: $e');
    }
  }
}
