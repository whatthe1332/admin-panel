import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/gendercategory_model.dart';
import 'package:flutter_ltdddoan/repositories/genderCategory/genderCategory_repository.dart';
import 'package:flutter_ltdddoan/widgets/content_view.dart';

class AddGenderCategoryPage extends StatefulWidget {
  const AddGenderCategoryPage({Key? key}) : super(key: key);

  @override
  _AddGenderCategoryPageState createState() => _AddGenderCategoryPageState();
}

class _AddGenderCategoryPageState extends State<AddGenderCategoryPage> {
  late final TextEditingController _nameController;
  late bool _isActive;
  late final GenderCategoryRepository _genderCategoryRepository;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _isActive = true; // Set default value for IsActive
    _genderCategoryRepository = GenderCategoryRepository();
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm'),
                  onPressed: _saveGenderCategory,
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

  Future<void> _saveGenderCategory() async {
    final newGenderCategory = GenderCategory(
      genderCategoryId: '',
      name: _nameController.text,
      isActive: _isActive,
      createdBy: 'Admin',
      createDate: DateTime.now(),
      updatedDate: DateTime.now(),
      updatedBy: 'Admin',
    );

    try {
      await _genderCategoryRepository.addGenderCategory(newGenderCategory);
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error saving gender category: $e');
    }
  }
}
