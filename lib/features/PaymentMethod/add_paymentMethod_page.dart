import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/paymentmethod_model.dart';
import 'package:flutter_ltdddoan/repositories/payment/paymentmethod_repository.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/widgets.dart';

class AddPaymentMethodPage extends StatefulWidget {
  const AddPaymentMethodPage({Key? key}) : super(key: key);

  @override
  _AddPaymentMethodPageState createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  PaymentMethodRepository paymentMethodRepository = PaymentMethodRepository();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isActive = false;
  String _tempImagePath = '';
  int? _hoveredImageIndex;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
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
                  onPressed: _savePaymentMethod,
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

  List<Widget> _buildImageWidgets() {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: MouseRegion(
          // Khi người dùng rê vào hình ảnh
          onEnter: (_) => _startHover(0),
          // Khi người dùng dừng rê vào hình ảnh
          onExit: (_) => _stopHover(),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  // Xử lý khi người dùng nhấn vào hình ảnh
                },
                child: Image.network(
                  _tempImagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              // Nút xóa chỉ hiển thị khi chỉ số của hình ảnh khớp với hình ảnh được rê vào
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

  void _savePaymentMethod() async {
    final newPaymentMethod = PaymentMethod(
      paymentMethodId: '',
      name: _nameController.text,
      isActive: _isActive,
      createdBy: 'Admin',
      createDate: DateTime.now(),
      updatedDate: DateTime.now(),
      updatedBy: 'Admin',
      description: _descriptionController.text,
      icon: '',
    );

    try {
      await paymentMethodRepository.addPaymentMethod(
          newPaymentMethod, _tempImagePath);
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error add payment method: $e');
    }
  }
}
