import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/discount_model.dart';
import 'package:flutter_ltdddoan/repositories/discount/discount_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';
import '../../widgets/widgets.dart';

class AddDiscountPage extends StatefulWidget {
  const AddDiscountPage({Key? key}) : super(key: key);

  @override
  _AddDiscountPageState createState() => _AddDiscountPageState();
}

class _AddDiscountPageState extends State<AddDiscountPage> {
  DiscountRepository discountRepository = DiscountRepository();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  bool _isActive = false;
  String _tempImagePath = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _valueController = TextEditingController();
    _quantityController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
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
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm'),
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

  void _startHover(int index) {
    // Hover effect logic goes here
  }

  void _stopHover() {
    // Hover effect logic goes here
  }

  void _saveDiscount() async {
    final newDiscount = Discount(
      name: _nameController.text,
      description: _descriptionController.text,
      value: double.tryParse(_valueController.text) ?? 0,
      quantity: int.tryParse(_quantityController.text) ?? 0,
      price: double.tryParse(_priceController.text) ?? 0,
      isActive: _isActive,
      createDate: DateTime.now(),
      updatedDate: DateTime.now(),
      discountId: '',
      createdBy: 'admin',
      updatedBy: 'admin',
      image: '',
    );

    try {
      await discountRepository.addDiscount(newDiscount, _tempImagePath);
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error saving discount: $e');
    }
  }
}
