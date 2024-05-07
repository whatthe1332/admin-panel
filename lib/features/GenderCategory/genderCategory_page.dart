import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/gendercategory_model.dart';
import 'package:flutter_ltdddoan/repositories/genderCategory/genderCategory_repository.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class GenderCategoryPage extends StatefulWidget {
  const GenderCategoryPage({Key? key, required this.genderCategory})
      : super(key: key);

  final GenderCategory genderCategory;

  @override
  _GenderCategoryPageState createState() => _GenderCategoryPageState();
}

class _GenderCategoryPageState extends State<GenderCategoryPage> {
  late final TextEditingController _nameController;
  late bool _isActive;
  late final GenderCategoryRepository _genderCategoryRepository;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.genderCategory.name);
    _isActive = widget.genderCategory.isActive;
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
                  onPressed: _saveGenderCategory,
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

  Future<void> _saveGenderCategory() async {
    final updatedGenderCategory = GenderCategory(
      genderCategoryId: widget.genderCategory.genderCategoryId,
      name: _nameController.text,
      isActive: _isActive,
      createdBy: widget.genderCategory.createdBy,
      createDate: widget.genderCategory.createDate,
      updatedDate: DateTime.now(),
      updatedBy: widget.genderCategory.updatedBy,
    );

    try {
      await _genderCategoryRepository.editGenderCategory(updatedGenderCategory);
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error saving gender category: $e');
    }
  }
}
